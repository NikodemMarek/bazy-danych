CREATE TABLE IF NOT EXISTS stocks (
    id SERIAL PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL UNIQUE,
    company_name VARCHAR(100) NOT NULL,
    last_price NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO stocks (symbol, company_name, last_price) VALUES
('GOOGL', 'Alphabet Inc. (Google)', 140.55),
('APPL', 'Apple Inc.', 175.80),
('MSFT', 'Microsoft Corp.', 410.20);
