CREATE OR REPLACE VIEW v_user_portfolio_valuation AS
SELECT
u.id as user_id,
u.email,
w.name as wallet_name,
i.ticker,
p.quantity,
i.bid_price as current_market_price,
(p.quantity * i.bid_price) AS current_value,
w.currency
-- Ewentualnie całkowita wycena portfela użytkownika
-- ,(SELECT SUM(p2.quantity * i2.bid_price)
--  FROM portfolio p2
--  JOIN instrument i2 ON p2.iid = i2.id
--  JOIN wallet w2 ON p2.wid = w2.id
--  WHERE w2.uid = u.id) AS total_portfolio_value
FROM portfolio p
JOIN wallet w ON p.wid = w.id
JOIN "user" u ON w.uid = u.id
JOIN instrument i ON p.iid = i.id
WHERE p.quantity > 0;

CREATE OR REPLACE VIEW v_transaction_history AS
SELECT
t.id as transaction_id,
u.email as user_email,
i.ticker,
t.quantity,
t.price,
t.fee,
((t.quantity * t.price) + t.fee) AS total_cost,
t.made_at
FROM "transaction" t
JOIN wallet w ON t.wid = w.id
JOIN "user" u ON w.uid = u.id
JOIN instrument i ON t.iid = i.id
ORDER BY t.made_at DESC;

CREATE OR REPLACE VIEW v_active_orders AS
SELECT
w.uid as user_id,
w.id as wallet_id,
o.id as order_id,
i.ticker,
o.side as transaction_type,
o.quantity,
o.limit_price,
o.created_at
FROM "order" o
JOIN wallet w ON o.wid = w.id
JOIN instrument i ON o.iid = i.id
WHERE o.status = 'open';

CREATE OR REPLACE VIEW v_price_history AS
SELECT
i.ticker,
ph.interval,
ph.timestamp,
ph.open,
ph.close,
ph.high,
ph.low,
ph.volume
FROM price_history ph
JOIN instrument i ON ph.iid = i.id;