CREATE OR REPLACE PROCEDURE distribute_dividend(p_ticker VARCHAR(8), p_amount_per_share DECIMAL(15, 2)) AS $$
DECLARE
    v_instrument_id INT;
    v_total_distributed DECIMAL(20, 2) := 0;
BEGIN
    SELECT id INTO v_instrument_id FROM instrument WHERE ticker = p_ticker;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Instrument o tickerze % nie istnieje.', p_ticker;
    END IF;

    UPDATE wallet w
    SET balance = balance + (p_amount_per_share * p.quantity)
    FROM portfolio p
    WHERE p.iid = v_instrument_id AND p.wid = w.id AND p.quantity > 0;

    SELECT SUM(p_amount_per_share * p.quantity) INTO v_total_distributed
    FROM portfolio p
    WHERE p.iid = v_instrument_id AND p.quantity > 0;
    
    RAISE NOTICE 'Wyplacono dywidende dla spolki %. Laczna kwota: %', p_ticker, v_total_distributed;
END;
$$ LANGUAGE plpgsql;

-- procedura do archiwizacji szczegółowych danych, niepotrzebnych do codziennych operacji (np. dane z interwałem minutowym starsze niż 30 dni)
CREATE OR REPLACE PROCEDURE archive_prices(p_retention_days INT DEFAULT 30, p_retention_years INT DEFAULT 5) AS $$
DECLARE
    v_rows_archived INT;
    v_deleted_old_archive INT;
BEGIN
    WITH moved_rows AS (
        DELETE FROM price_history
        WHERE interval IN ('1m', '1h')
        AND timestamp < NOW() - INTERVAL '1 day' * p_retention_days
        RETURNING *
    )
    INSERT INTO price_history_archive SELECT * FROM moved_rows;
    GET DIAGNOSTICS v_rows_archived = ROW_COUNT;
    
    DELETE FROM price_history_archive
    WHERE timestamp < NOW() - INTERVAL '1 year' * p_retention_years;

    GET DIAGNOSTICS v_deleted_old_archive = ROW_COUNT;
    RAISE NOTICE 'Zarchiwizowano % wierszy z price_history i usunięto % wierszy ze starego archiwum.', v_rows_archived, v_deleted_old_archive;
END;
$$ LANGUAGE plpgsql;
