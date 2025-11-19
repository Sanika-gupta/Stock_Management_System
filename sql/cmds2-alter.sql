USE stock_mgmt_sys;

-- Update 'user' table: change date_joined to DATETIME with default current timestamp
ALTER TABLE user
    MODIFY date_joined DATETIME DEFAULT CURRENT_TIMESTAMP;

-- Update 'portfolio' table: change created_date to DATETIME with default current timestamp
ALTER TABLE portfolio
    MODIFY created_date DATETIME DEFAULT CURRENT_TIMESTAMP;

-- Update 'holding' table: change last_updated to DATETIME with default current timestamp
ALTER TABLE holding
    MODIFY last_updated DATETIME DEFAULT CURRENT_TIMESTAMP;

-- Add 'role' column to 'user' table
ALTER TABLE user
    ADD COLUMN role ENUM('USER', 'ADMIN') DEFAULT 'USER';

-- Update 'admin' table: set role as ENUM with default 'Manager'
ALTER TABLE admin
    MODIFY role ENUM('SuperAdmin', 'Manager') DEFAULT 'Manager';

-- Add cascading foreign key to 'portfolio' table for user_id
ALTER TABLE portfolio
    ADD CONSTRAINT fk_user
    FOREIGN KEY (user_id) REFERENCES user(user_id)
    ON DELETE CASCADE;

-- Add cascading foreign keys to 'holding' table for p_id and s_id
ALTER TABLE holding
    ADD CONSTRAINT fk_portfolio
    FOREIGN KEY (p_id) REFERENCES portfolio(p_id)
    ON DELETE CASCADE,
    ADD CONSTRAINT fk_stock
    FOREIGN KEY (s_id) REFERENCES stock(s_id)
    ON DELETE CASCADE;

-- Add cascading foreign keys to 'transaction' table for p_id and s_id
ALTER TABLE transaction
    ADD CONSTRAINT fk_portfolio_trans
    FOREIGN KEY (p_id) REFERENCES portfolio(p_id)
    ON DELETE CASCADE,
    ADD CONSTRAINT fk_stock_trans
    FOREIGN KEY (s_id) REFERENCES stock(s_id)
    ON DELETE CASCADE;

-- Add description column to 'stock' table
ALTER TABLE stock
    ADD COLUMN description TEXT;

-- Optional: verify all table structures after modification
SHOW TABLES;
DESC user;
DESC admin;
DESC portfolio;
DESC holding;
DESC transaction;
DESC stock;
