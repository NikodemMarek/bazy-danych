CREATE TYPE u_status AS ENUM(
    'active',
    'suspended',
    'closed'
);

CREATE TYPE o_status as ENUM(
    'open',
    'filled',
    'cancelled'
);

CREATE TYPE ph_interval AS ENUM(
    '1m',
    '1h',
    '1d',
    '1w',
    '1M'
);

CREATE TABLE IF NOT EXISTS "user"(
    id SERIAL PRIMARY KEY,
    name varchar(50) NOT NULL,
    surname varchar(50) NOT NULL,
    bank_account varchar(34),
    email varchar(255) NOT NULL,
    password_hash varchar(255) NOT NULL,
    created_at timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    status u_status DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS wallet(
    id SERIAL PRIMARY KEY,
    uid int NOT NULL,
    name varchar(255) NOT NULL,
    balance DECIMAL(15, 2) NOT NULL,
    currency varchar(3) NOT NULL,

    CONSTRAINT fk_wallet_user
        FOREIGN KEY(uid)
        REFERENCES "user"(id)
);

CREATE TABLE IF NOT EXISTS instrument_type(
    id SERIAL PRIMARY KEY,
    name varchar(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS instrument(
    id SERIAL PRIMARY KEY,
    itid int NOT NULL,
    ticker varchar(8) NOT NULL,
    country varchar(50) NOT NULL,
    ask_price decimal(15, 2),
    bid_price decimal(15, 2),

    CONSTRAINT fk_ins_type
        FOREIGN KEY(itid)
        REFERENCES instrument_type(id)
);

CREATE TABLE IF NOT EXISTS portfolio(
    id SERIAL PRIMARY KEY,
    wid int NOT NULL,
    iid int NOT NULL,
    quantity decimal(18, 8),

    CONSTRAINT fk_portfolio_wallet
        FOREIGN KEY(wid)
        REFERENCES wallet(id),

    CONSTRAINT fk_portfolio_instrument
        FOREIGN KEY(iid)
        REFERENCES instrument(id)
);

CREATE TABLE IF NOT EXISTS "order"(
    id SERIAL PRIMARY KEY,
    wid int NOT NULL,
    iid int NOT NULL,
    quantity decimal(18, 8) NOT NULL,
    limit_price decimal(15, 2),
    status o_status NOT NULL DEFAULT 'open',
    created_at timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    closed_at timestamp WITH TIME ZONE,

    CONSTRAINT fk_order_wallet
        FOREIGN KEY(wid)
        REFERENCES wallet(id),

    CONSTRAINT fk_order_instrument
        FOREIGN KEY(iid)
        REFERENCES instrument(id)
);

CREATE TABLE IF NOT EXISTS "transaction"(
    id SERIAL PRIMARY KEY,
    oid int NOT NULL,
    wid int NOT NULL,
    iid int NOT NULL,
    quantity decimal(18, 8) NOT NULL,
    price decimal(15, 2) NOT NULL,
    fee decimal(15, 2) NOT NULL,
    made_at timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_transaction_order
        FOREIGN KEY(oid)
        REFERENCES "order"(id),

    CONSTRAINT fk_transaction_wallet
        FOREIGN KEY(wid)
        REFERENCES wallet(id),

    CONSTRAINT fk_transaction_instrument
        FOREIGN KEY(iid)
        REFERENCES instrument(id)
);

CREATE TABLE IF NOT EXISTS price_history(
    id SERIAL PRIMARY KEY,
    iid int NOT NULL,
    timestamp timestamp WITH TIME ZONE,
    interval ph_interval NOT NULL DEFAULT '1h',
    open decimal(15, 2) NOT NULL,
    high decimal(15, 2) NOT NULL,
    low decimal(15, 2) NOT NULL,
    close decimal(15, 2) NOT NULL,
    volume decimal(18, 8),

    CONSTRAINT fk_ph_instrument
        FOREIGN KEY(iid)
        REFERENCES instrument(id)
);