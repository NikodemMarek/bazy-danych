CREATE OR REPLACE FUNCTION order_id_with_the_same_price(
    p_iid INT,
    p_limit_price DECIMAL(15, 2),
    p_order_side transaction_side,
    p_exclude_wid INT
)
RETURNS INT AS $$
DECLARE
    matching_id INT;
BEGIN
    IF p_order_side = 'buy' THEN
        SELECT id INTO matching_id FROM "order"
        WHERE
            iid = p_iid
            AND status = 'open'
            AND side = 'sell'
            AND limit_price <= p_limit_price
            AND wid != p_exclude_wid
        ORDER BY limit_price ASC, created_at ASC
        LIMIT 1;
    ELSE
        SELECT id INTO matching_id FROM (
            SELECT id FROM "order" WHERE
                iid = p_iid
                AND status = 'open'
                AND side = 'buy'
                AND limit_price >= p_limit_price
                AND wid != p_exclude_wid
            ORDER BY limit_price DESC, created_at ASC
        ) AS sorted_orders LIMIT 1;
    END IF;

    RETURN matching_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION execute_trade(
    p_new_order RECORD,
    p_matched_order RECORD
)
RETURNS DECIMAL AS $$
DECLARE
    v_fee_percentage DECIMAL := 0.01;

    transaction_quantity DECIMAL;
    buyer_wid INT;
    seller_wid INT;
    buyer_oid INT;
    seller_oid INT;

    matched_order_remaining_qty DECIMAL;
    new_order_remaining_qty DECIMAL;
BEGIN
    transaction_quantity := LEAST(ABS(p_new_order.quantity), ABS(p_matched_order.quantity));

    IF p_new_order.side = 'buy' THEN
        buyer_wid := p_new_order.wid; buyer_oid := p_new_order.id;
        seller_wid := p_matched_order.wid; seller_oid := p_matched_order.id;
    ELSE
        seller_wid := p_new_order.wid; seller_oid := p_new_order.id;
        buyer_wid := p_matched_order.wid; buyer_oid := p_matched_order.id;
    END IF;

    matched_order_remaining_qty := p_matched_order.quantity - transaction_quantity;
    new_order_remaining_qty := p_new_order.quantity - transaction_quantity;

    UPDATE "order" SET status = 'filled' WHERE id = p_matched_order.id;
    UPDATE "order" SET status = 'filled' WHERE id = p_new_order.id;

    IF matched_order_remaining_qty > 0 OR new_order_remaining_qty > 0 THEN
        IF matched_order_remaining_qty > 0 THEN
            INSERT INTO "order" (wid, iid, quantity, limit_price) VALUES
            (p_matched_order.wid, p_matched_order.iid, matched_order_remaining_qty * sign(p_matched_order.quantity), p_matched_order.limit_price);
        ELSE
            INSERT INTO "order" (wid, iid, quantity, limit_price) VALUES
            (p_new_order.wid, p_new_order.iid, new_order_remaining_qty * sign(p_new_order.quantity), p_new_order.limit_price);
        END IF;
    END IF;

    INSERT INTO "transaction" (oid, wid, iid, quantity, price, fee) VALUES
    (buyer_oid, buyer_oid, p_matched_order.iid, transaction_quantity, p_matched_order.limit_price, transaction_quantity * p_matched_order.limit_price * v_fee_percentage),
    (seller_oid, seller_oid, p_new_order.iid, -transaction_quantity, p_new_order.limit_price, transaction_quantity * p_new_order.limit_price * v_fee_percentage);

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION process_order_matching()
RETURNS TRIGGER AS $$
DECLARE
    matched_order_id INT;
    matched_order RECORD;
BEGIN
    matched_order_id := order_id_with_the_same_price(NEW.iid, NEW.limit_price, NEW.side, NEW.wid);
    IF matched_order_id IS NULL THEN
        RETURN NULL;
    END IF;

    SELECT * INTO matched_order FROM "order" WHERE id = matched_order_id FOR UPDATE NOWAIT;

    PERFORM execute_trade(NEW, matched_order);

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_process_order_matching_after_insert
AFTER INSERT ON "order"
FOR EACH ROW EXECUTE FUNCTION process_order_matching();
