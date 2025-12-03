CREATE OR REPLACE FUNCTION set_order_closed_at()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status IS DISTINCT FROM NEW.status AND (NEW.status = 'filled' OR NEW.status = 'cancelled') THEN
        NEW.closed_at = CURRENT_TIMESTAMP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_set_order_closed_at
BEFORE UPDATE ON "order"
FOR EACH ROW
EXECUTE FUNCTION set_order_closed_at();

CREATE OR REPLACE FUNCTION prevent_closed_order_modification()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status = 'filled' OR OLD.status = 'cancelled' THEN
        RAISE EXCEPTION 'Cannot modify a closed order (order_id: %)', OLD.id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_closed_order_modification
BEFORE UPDATE ON "order"
FOR EACH ROW
EXECUTE FUNCTION prevent_closed_order_modification();

CREATE OR REPLACE FUNCTION update_instrument_price_from_transaction()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE instrument
    SET ask_price = NEW.price, bid_price = NEW.price
    WHERE id = NEW.iid;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_instrument_price
AFTER INSERT ON "transaction"
FOR EACH ROW
EXECUTE FUNCTION update_instrument_price_from_transaction();

CREATE OR REPLACE FUNCTION prevent_negative_wallet_balance()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.balance < 0 THEN
        RAISE EXCEPTION 'Wallet balance cannot be negative (wallet_id: %)', NEW.id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_negative_balance
BEFORE UPDATE ON wallet
FOR EACH ROW
EXECUTE FUNCTION prevent_negative_wallet_balance();
