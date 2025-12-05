INSERT INTO "user" (name, surname, bank_account, email, password_hash, status) VALUES
('Jan', 'Kowalski', 'PL123456789012345678901234', 'jan.kowalski@email.com', 'hash123_abc', 'active'),
('Anna', 'Nowak', 'PL234567890123456789012345', 'anna.nowak@email.com', 'hash456_def', 'active'),
('Piotr', 'Wiśniewski', 'PL345678901234567890123456', 'piotr.w@email.com', 'hash789_ghi', 'active'),
('Maria', 'Wójcik', 'PL456789012345678901234567', 'maria.wojcik@email.com', 'hash101_jkl', 'suspended'),
('Krzysztof', 'Kowalczyk', 'PL567890123456789012345678', 'krzys.k@email.com', 'hash112_mno', 'active'),
('Ewa', 'Kamińska', 'PL678901234567890123456789', 'ewa.kam@email.com', 'hash131_pqr', 'closed'),
('Tomasz', 'Zieliński', 'PL789012345678901234567890', 'tomasz.ziel@email.com', 'hash141_stu', 'active'),
('Barbara', 'Szymańska', 'PL890123456789012345678901', 'basia.sz@email.com', 'hash151_vwx', 'active'),
('Marek', 'Dąbrowski', 'PL901234567890123456789012', 'marek.d@email.com', 'hash161_yza', 'active'),
('Zofia', 'Lewandowska', 'PL012345678901234567890123', 'zofia.l@email.com', 'hash171_bcd', 'active');

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
-- sell 10 CDR @ 110
-- INSERT INTO "order" (wid, iid, quantity, limit_price) VALUES (1, 1, -10.0, 110.00);
-- buy 5 CDR @ 110
-- INSERT INTO "order" (wid, iid, quantity, limit_price) VALUES (2, 1, 5.0, 110.00);
-- buy 8 CDR @ 110
-- INSERT INTO "order" (wid, iid, quantity, limit_price) VALUES (2, 1, 8.0, 110.00);
-- sell 2 CDR @ 110
-- INSERT INTO "order" (wid, iid, quantity, limit_price) VALUES (1, 1, -2.0, 110.00);
-- sell 2 CDR @ 110
-- INSERT INTO "order" (wid, iid, quantity, limit_price) VALUES (1, 1, -2.0, 110.00);
-- buy 1 CDR @ 110
-- INSERT INTO "order" (wid, iid, quantity, limit_price) VALUES (2, 1, 1.0, 110.00);
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
