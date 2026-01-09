CREATE ROLE group_admin;
CREATE ROLE group_application;
CREATE ROLE group_analyst;
-- Admin privileges
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO group_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO group_admin;
-- Application can connect and use schema
GRANT CONNECT ON DATABASE stockmarket TO group_application;
GRANT USAGE ON SCHEMA public TO group_application;
-- Application can modify (INSERT/UPDATE) selected tables
GRANT SELECT, INSERT, UPDATE ON TABLE "user", "wallet", "portfolio", "order" TO group_application;
-- Special case "transaction" - application can only read from it and add new records
GRANT SELECT, INSERT ON TABLE "transaction" TO group_application;
-- Read-only access to tables
GRANT SELECT ON TABLE "instrument", "instrument_type", "price_history", "price_history_archive" TO group_application;
-- Serial and auto-increment has to work
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO group_application;
-- Analyst can only read from all tables
GRANT SELECT ON ALL TABLES IN SCHEMA public TO group_analyst;

GRANT SELECT ON v_user_portfolio_valuation, v_active_orders, v_transaction_history, v_price_history TO group_application;
GRANT SELECT ON v_user_portfolio_valuation, v_active_orders, v_transaction_history, v_price_history TO group_analyst;