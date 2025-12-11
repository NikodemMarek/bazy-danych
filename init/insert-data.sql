INSERT INTO "user" (name, surname, bank_account, email, password_hash, status) VALUES
('Jan', 'Kowalski', 'PL123456789012345678901234', 'jan.kowalski@email.com', crypt('hash123_abc', gen_salt('bf')), 'active'),
('Anna', 'Nowak', 'PL234567890123456789012345', 'anna.nowak@email.com', crypt('hash456_def', gen_salt('bf')), 'active'),
('Piotr', 'Wiśniewski', 'PL345678901234567890123456', 'piotr.w@email.com', crypt('hash789_ghi', gen_salt('bf')), 'active'),
('Maria', 'Wójcik', 'PL456789012345678901234567', 'maria.wojcik@email.com', crypt('hash101_jkl', gen_salt('bf')), 'suspended'),
('Krzysztof', 'Kowalczyk', 'PL567890123456789012345678', 'krzys.k@email.com', crypt('hash112_mno', gen_salt('bf')), 'active'),
('Ewa', 'Kamińska', 'PL678901234567890123456789', 'ewa.kam@email.com', crypt('hash131_pqr',gen_salt('bf')), 'closed'),
('Tomasz', 'Zieliński', 'PL789012345678901234567890', 'tomasz.ziel@email.com', crypt('hash141_stu', gen_salt('bf')), 'active'),
('Barbara', 'Szymańska', 'PL890123456789012345678901', 'basia.sz@email.com', crypt('hash151_vwx', gen_salt('bf')), 'active'),
('Marek', 'Dąbrowski', 'PL901234567890123456789012', 'marek.d@email.com', crypt('hash161_yza', gen_salt('bf')), 'active'),
('Zofia', 'Lewandowska', 'PL012345678901234567890123', 'zofia.l@email.com', crypt('hash171_bcd', gen_salt('bf')), 'active');

INSERT INTO instrument_type (name) VALUES
('akcja'),
('ETF'),
('kryptowaluta'),
('surowiec');

INSERT INTO instrument (itid, ticker, country, ask_price, bid_price) VALUES
(1, 'CDR', 'PL', 110.50, 110.40), -- itid 1 = Akcja
(1, 'PKO', 'PL', 58.20, 58.15), -- itid 1 = Akcja
(1, 'AAPL', 'USA', 175.80, 175.75), -- itid 1 = Akcja
(1, 'TSLA', 'USA', 175.20, 175.10), -- itid 1 = Akcja
(2, 'ETFW20', 'PL', 45.00, 44.95), -- itid 2 = ETF
(2, 'SPY500', 'USA', 500.00, 499.90), -- itid 2 = ETF
(3, 'BTC', 'GLOBAL', 60000.00, 59990.00), -- itid 3 = Kryptowaluta
(3, 'ETH', 'GLOBAL', 3000.00, 2999.50), -- itid 3 = Kryptowaluta
(4, 'XAU', 'GLOBAL', 2000.00, 1999.80), -- itid 4 = Surowiec (Złoto)
(4, 'XAG', 'GLOBAL', 25.00, 24.98); -- itid 4 = Surowiec (Srebro)

INSERT INTO wallet (uid, name, balance, currency) VALUES
(1, 'Portfel główny PLN', 10000.00, 'PLN'),
(1, 'Akcje USA', 5000.00, 'USD'),
(2, 'Oszczędności', 15000.00, 'PLN'),
(3, 'Portfel Krypto', 8000.00, 'USD'),
(4, 'IKE', 25000.00, 'PLN'),
(5, 'Portfel ETF', 12000.00, 'EUR'),
(7, 'Surowce', 7000.00, 'USD'),
(8, 'Portfel testowy', 100.00, 'PLN'),
(9, 'Portfel dywidendowy', 30000.00, 'PLN'),
(10, 'Portfel spekulacyjny', 500.00, 'USD');

INSERT INTO portfolio (wid, iid, quantity) VALUES
(1, 1, 50.0),    -- Portfel 1 (PLN) posiada 50 szt. instrumentu 1 (CDR)
(1, 2, 100.0),   -- Portfel 1 (PLN) posiada 100 szt. instrumentu 2 (PKO)
(2, 3, 10.0),    -- Portfel 2 (USD) posiada 10 szt. instrumentu 3 (AAPL)
(2, 4, 20.0),    -- Portfel 2 (USD) posiada 20 szt. instrumentu 4 (TSLA)
(3, 5, 200.0),   -- Portfel 3 (PLN) posiada 200 szt. instrumentu 5 (ETFW20)
(4, 7, 0.5),     -- Portfel 4 (USD) posiada 0.5 szt. instrumentu 7 (BTC)
(4, 8, 5.0),     -- Portfel 4 (USD) posiada 5 szt. instrumentu 8 (ETH)
(6, 6, 30.0),    -- Portfel 6 (EUR) posiada 30 szt. instrumentu 6 (SPY500)
(7, 9, 10.0),    -- Portfel 7 (USD) posiada 10 szt. instrumentu 9 (Złoto)
(9, 1, 75.0);    -- Portfel 9 (PLN) posiada 75 szt. instrumentu 1 (CDR)


-- execute to test automatic order fufillment:
-- INSERT INTO "order" (wid, iid, quantity, limit_price, side) VALUES (1, 1, 10.0, 110.00, 'sell');
-- INSERT INTO "order" (wid, iid, quantity, limit_price, side) VALUES (2, 1, 5.0, 110.00, 'buy');
-- INSERT INTO "order" (wid, iid, quantity, limit_price, side) VALUES (2, 1, 8.0, 110.00, 'buy');
-- INSERT INTO "order" (wid, iid, quantity, limit_price, side) VALUES (1, 1, 2.0, 110.00, 'sell');
-- INSERT INTO "order" (wid, iid, quantity, limit_price, side) VALUES (1, 1, 2.0, 110.00, 'sell');
-- INSERT INTO "order" (wid, iid, quantity, limit_price, side) VALUES (2, 1, 1.0, 110.00, 'buy');
-- should result in:
--  id | wid | iid |   quantity   | limit_price | status |          created_at           | closed_at
-- ----+-----+-----+--------------+-------------+--------+-------------------------------+-----------
--   1 |   1 |   1 | -10.00000000 |      110.00 | filled | 2025-12-01 12:00:00.000000+00 |
--   2 |   2 |   1 |   5.00000000 |      110.00 | filled | 2025-12-01 12:00:00.100000+00 |
--   3 |   1 |   1 |  -5.00000000 |      110.00 | filled | 2025-12-01 12:00:00.200000+00 |
--   4 |   2 |   1 |   8.00000000 |      110.00 | filled | 2025-12-01 12:00:00.300000+00  |
--   5 |   2 |   1 |   3.00000000 |      110.00 | filled | 2025-12-01 12:00:00.400000+00  |
--   6 |   1 |   1 |  -2.00000000 |      110.00 | filled | 2025-12-01 12:00:00.500000+00 |
--   7 |   2 |   1 |   1.00000000 |      110.00 | filled | 2025-12-01 12:00:00.600000+00 |
--   8 |   1 |   1 |  -2.00000000 |      110.00 | filled | 2025-12-01 12:00:00.700000+00 |
--   9 |   1 |   1 |  -1.00000000 |      110.00 | filled | 2025-12-01 12:00:00.800000+00 |
--  10 |   2 |   1 |   1.00000000 |      110.00 | filled | 2025-12-01 12:00:00.900000+00 |
-- (10 rows)

INSERT INTO "order" (wid, iid, side, quantity, limit_price, status, created_at, closed_at) VALUES
-- ZREALIZOWANE (To one zbudowały obecne portfolio)
(1, 1, 'buy', 50.0, 105.00, 'filled', NOW() - INTERVAL '11 days', NOW() - INTERVAL '10 days'), -- Kupił CDR (PLN)
(1, 2, 'buy', 100.0, 55.50, 'filled', NOW() - INTERVAL '6 days', NOW() - INTERVAL '5 days'),   -- Kupił PKO (PLN)
(2, 3, 'buy', 10.0, 170.00, 'filled', NOW() - INTERVAL '21 days', NOW() - INTERVAL '20 days'), -- Kupił AAPL (USD)
(4, 7, 'buy', 0.5, 15000.00, 'filled', NOW() - INTERVAL '3 days', NOW() - INTERVAL '2 days'),  -- Kupił BTC (USD)

-- OTWARTE (Wiszące na giełdzie - widoczne w arkuszu zleceń)
(1, 1, 'buy', 10.0, 100.00, 'open', NOW() - INTERVAL '1 hour', NULL),    -- Chce dokupić CDR taniej (Limit 100)
(2, 4, 'sell', 5.0, 180.00, 'open', NOW() - INTERVAL '3 hours', NULL),    -- Chce sprzedać TSLA drożej (Limit 180)
(3, 8, 'buy', 2.0, 2900.00, 'open', NOW() - INTERVAL '12 hours', NULL),  -- Chce kupić ETH (USD)
(5, 5, 'buy', 50.0, 44.00, 'open', NOW() - INTERVAL '1 day', NULL),      -- Chce kupić ETFW20 (PLN)

-- ANULOWANE (Historia niedoszłych transakcji)
(9, 1, 'buy', 100.0, 90.00, 'cancelled', NOW() - INTERVAL '1 month', NOW() - INTERVAL '29 days'); -- Chciał kupić CDR bardzo tanio, ale zrezygnował

INSERT INTO "transaction" (oid, wid, iid, side, quantity, price, fee, made_at) VALUES
(5, 1, 1, 'buy', 50.0, 105.00, 2.50, NOW() - INTERVAL '10 days'),  -- Kupno CDR
(6, 1, 2, 'buy', 100.0, 55.50, 3.00, NOW() - INTERVAL '5 days'),   -- Kupno PKO
(7, 2, 3, 'buy', 10.0, 170.00, 1.50, NOW() - INTERVAL '20 days'),  -- Kupno AAPL
(8, 4, 7, 'buy', 0.5, 15000.00, 10.00, NOW() - INTERVAL '2 days'); -- Kupno BTC

INSERT INTO price_history (iid, timestamp, interval, open, high, low, close, volume) VALUES
-- === CD PROJEKT (CDR) - Interwał 1 dzień (1d) ===
(1, NOW() - INTERVAL '5 days', '1d', 105.00, 107.50, 104.00, 106.00, 15000),
(1, NOW() - INTERVAL '4 days', '1d', 106.00, 109.00, 105.50, 108.50, 22000),
(1, NOW() - INTERVAL '3 days', '1d', 108.50, 110.00, 108.00, 109.50, 18500),
(1, NOW() - INTERVAL '2 days', '1d', 109.50, 111.00, 109.00, 110.00, 12000),
(1, NOW() - INTERVAL '1 day', '1d', 110.00, 112.00, 109.50, 110.50, 16000),

-- === BITCOIN (BTC) - Interwał 1 godzina (1h) - Ostatnie 5 godzin ===
(7, NOW() - INTERVAL '5 hours', '1h', 59500.00, 59800.00, 59400.00, 59700.00, 120.5),
(7, NOW() - INTERVAL '4 hours', '1h', 59700.00, 60100.00, 59600.00, 60000.00, 145.2),
(7, NOW() - INTERVAL '3 hours', '1h', 60000.00, 60200.00, 59900.00, 60100.00, 98.0),
(7, NOW() - INTERVAL '2 hours', '1h', 60100.00, 60150.00, 59800.00, 59900.00, 110.1),
(7, NOW() - INTERVAL '1 hour', '1h', 59900.00, 60050.00, 59850.00, 60000.00, 85.5),

-- === APPLE (AAPL) - Interwał 1 tydzień (1w) ===
(3, NOW() - INTERVAL '3 weeks', '1w', 165.00, 170.00, 164.00, 168.00, 500000),
(3, NOW() - INTERVAL '2 weeks', '1w', 168.00, 172.00, 167.00, 171.00, 600000),
(3, NOW() - INTERVAL '1 weeks', '1w', 171.00, 176.00, 170.00, 175.80, 550000);
