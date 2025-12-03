CREATE OR REPLACE FUNCTION verify_order_requirements()
RETURNS TRIGGER AS $$
DECLARE
    wallet_balance DECIMAL(15, 2);
    instrument_ask_price DECIMAL(15, 2);
    instrument_bid_price DECIMAL(15, 2);
    portfolio_quantity DECIMAL(18, 8);
    required_funds DECIMAL(15, 2);
    fee DECIMAL(15, 2) := 0.01;
BEGIN
    IF NEW.quantity > 0 THEN
        SELECT balance INTO wallet_balance FROM wallet WHERE id = NEW.wid;
        SELECT ask_price INTO instrument_ask_price FROM instrument WHERE id = NEW.iid;

        IF instrument_ask_price IS NULL THEN
            RAISE EXCEPTION 'No ask price for instrument %', NEW.iid;
        END IF;

        required_funds := (NEW.quantity * instrument_ask_price) + fee;

        IF wallet_balance < required_funds THEN
            RAISE EXCEPTION 'Insufficient funds in wallet %', NEW.wid;
        END IF;
    ELSIF NEW.quantity < 0 THEN
        SELECT quantity INTO portfolio_quantity FROM portfolio WHERE wid = NEW.wid AND iid = NEW.iid;

        IF portfolio_quantity IS NULL OR portfolio_quantity < ABS(NEW.quantity) THEN
            RAISE EXCEPTION 'Insufficient instrument quantity in portfolio for wallet %', NEW.wid;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verify_order_before_insert
BEFORE INSERT ON "order"
FOR EACH ROW
EXECUTE FUNCTION verify_order_requirements();

CREATE OR REPLACE FUNCTION create_transaction_on_order_filled()
RETURNS TRIGGER AS $$
DECLARE
    transaction_price DECIMAL(15, 2);
    fee DECIMAL(15, 2) := 0.01;
BEGIN
    IF OLD.status IS DISTINCT FROM 'filled' AND NEW.status = 'filled' THEN
        IF NEW.quantity > 0 THEN
            SELECT ask_price INTO transaction_price FROM instrument WHERE id = NEW.iid;
        ELSIF NEW.quantity < 0 THEN
            SELECT bid_price INTO transaction_price FROM instrument WHERE id = NEW.iid;
        END IF;

        IF transaction_price IS NOT NULL THEN
            INSERT INTO "transaction" (oid, wid, iid, quantity, price, fee)
            VALUES (NEW.id, NEW.wid, NEW.iid, NEW.quantity, transaction_price, fee);
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_create_transaction_on_fill
AFTER UPDATE ON "order"
FOR EACH ROW
EXECUTE FUNCTION create_transaction_on_order_filled();

CREATE OR REPLACE FUNCTION update_wallet_and_portfolio()
RETURNS TRIGGER AS $$
DECLARE
    transaction_value DECIMAL(15, 2);
    effective_quantity DECIMAL(18, 8);
BEGIN
    effective_quantity := ABS(NEW.quantity);

    IF NEW.quantity > 0 THEN
        transaction_value := (effective_quantity * NEW.price) + NEW.fee;
        UPDATE wallet SET balance = balance - transaction_value WHERE id = NEW.wid;

        INSERT INTO portfolio (wid, iid, quantity)
        VALUES (NEW.wid, NEW.iid, effective_quantity)
        ON CONFLICT (wid, iid) DO UPDATE
        SET quantity = portfolio.quantity + EXCLUDED.quantity;
    ELSIF NEW.quantity < 0 THEN
        transaction_value := (effective_quantity * NEW.price) - NEW.fee;
        UPDATE wallet SET balance = balance + transaction_value WHERE id = NEW.wid;

        UPDATE portfolio
        SET quantity = portfolio.quantity - effective_quantity
        WHERE wid = NEW.wid AND iid = NEW.iid;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_balance_on_transaction
AFTER INSERT ON "transaction"
FOR EACH ROW
EXECUTE FUNCTION update_wallet_and_portfolio();