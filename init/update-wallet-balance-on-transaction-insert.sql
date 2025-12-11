CREATE OR REPLACE FUNCTION update_wallet_balance()
RETURNS TRIGGER AS $$
DECLARE
    transaction_value DECIMAL(15, 2);
BEGIN
    IF NEW.side = 'buy' THEN
        transaction_value := NEW.quantity * NEW.price + NEW.fee;
        UPDATE wallet SET balance = balance - transaction_value WHERE id = NEW.wid;
    ELSIF NEW.side = 'sell' THEN
        transaction_value := NEW.quantity * NEW.price - NEW.fee;
        UPDATE wallet SET balance = balance + transaction_value WHERE id = NEW.wid;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_wallet_balance_on_transaction_insert
AFTER INSERT ON "transaction"
FOR EACH ROW EXECUTE FUNCTION update_wallet_balance();
