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

INSERT INTO "order" (wid, iid, quantity, limit_price, status, closed_at) VALUES
(1, 1, 10.0, 110.00, 'filled', CURRENT_TIMESTAMP), -- Kupno 10 CDR @ 110 (zrealizowane)
(2, 3, 5.0, 180.00, 'open', NULL), -- Chęć kupna 5 AAPL @ 180 (otwarte)
(3, 7, 0.1, 59000.00, 'open', NULL), -- Chęć kupna 0.1 BTC @ 59k (otwarte)
(4, 8, 2.0, 3100.00, 'cancelled', CURRENT_TIMESTAMP), -- Anulowane zlecenie na 2 ETH
(1, 2, -50.0, 58.00, 'filled', CURRENT_TIMESTAMP), -- Sprzedaż 50 PKO @ 58 (zrealizowane)
(6, 6, 10.0, 490.00, 'open', NULL), -- Chęć kupna 10 SPY500 @ 490 (otwarte)
(7, 9, -5.0, 2010.00, 'open', NULL), -- Chęć sprzedaży 5 Złota @ 2010 (otwarte)
(9, 1, 20.0, 115.00, 'filled', CURRENT_TIMESTAMP), -- Kupno 20 CDR @ 115 (zrealizowane)
(10, 7, 0.2, 61000.00, 'filled', CURRENT_TIMESTAMP), -- Kupno 0.2 BTC @ 61k (zrealizowane)
(2, 4, 10.0, 400.00, 'cancelled', CURRENT_TIMESTAMP); -- Anulowane zlecenie na 10 TSLA

-- Transakcja dla zlecenia 1 (Kupno 10 CDR)
INSERT INTO "transaction" (oid, wid, iid, quantity, price, fee) VALUES
(1, 1, 1, 10.0, 110.00, 0.50);

-- Transakcja dla zlecenia 5 (Sprzedaż 50 PKO)
INSERT INTO "transaction" (oid, wid, iid, quantity, price, fee) VALUES
(5, 1, 2, -50.0, 58.00, 1.20);

-- Transakcja dla zlecenia 8 (Kupno 20 CDR)
INSERT INTO "transaction" (oid, wid, iid, quantity, price, fee) VALUES
(8, 9, 1, 20.0, 115.00, 0.80);

-- Transakcja dla zlecenia 9 (Kupno 0.2 BTC)
INSERT INTO "transaction" (oid, wid, iid, quantity, price, fee) VALUES
(9, 10, 7, 0.2, 61000.00, 15.00);

-- (Dodaję 6 "sztucznych" wpisów, aby dobić do 10 - w realnym systemie mogłyby to być częściowe wypełnienia zleceń)
INSERT INTO "transaction" (oid, wid, iid, quantity, price, fee) VALUES
(1, 1, 1, 5.0, 109.50, 0.25), -- (Np. drugie wypełnienie zlecenia 1)
(5, 1, 2, -20.0, 58.10, 0.40), -- (Częściowe wypełnienie zlecenia 5)
(5, 1, 2, -30.0, 58.15, 0.60), -- (Dokończenie wypełnienia zlecenia 5)
(8, 9, 1, 10.0, 114.80, 0.40), -- (Część zlecenia 8)
(8, 9, 1, 10.0, 114.90, 0.40), -- (Druga część zlecenia 8)
(9, 10, 7, 0.1, 61050.00, 7.50); -- (Połowa zlecenia 9)

INSERT INTO price_history (iid, "timestamp", interval, open, high, low, "close", volume) VALUES
(1, '2025-11-15 09:00:00+01', '1h', 110.00, 111.00, 109.50, 110.50, 10000),
(1, '2025-11-15 10:00:00+01', '1h', 110.50, 112.00, 110.00, 111.80, 12000),
(2, '2025-11-15 09:00:00+01', '1h', 58.00, 58.50, 57.90, 58.20, 50000),
(3, '2025-11-14 00:00:00+01', '1d', 175.00, 176.00, 174.50, 175.80, 1000000),
(7, '2025-11-15 12:00:00+01', '1m', 60000.00, 60010.00, 59990.00, 60005.00, 50.5),
(7, '2025-11-15 12:01:00+01', '1m', 60005.00, 60020.00, 60000.00, 60015.00, 40.2),
(9, '2025-11-15 00:00:00+01', '1d', 2000.00, 2010.00, 1990.00, 2005.00, 8000),
(1, '2025-11-14 00:00:00+01', '1d', 108.00, 110.00, 107.50, 110.00, 150000),
(2, '2025-11-14 00:00:00+01', '1d', 57.00, 58.00, 57.00, 58.00, 600000),
(4, '2025-11-14 00:00:00+01', '1d', 400.00, 410.00, 399.00, 410.20, 900000);