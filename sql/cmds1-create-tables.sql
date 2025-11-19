-- Create Database
CREATE DATABASE IF NOT EXISTS stock_mgmt_sys;
USE stock_mgmt_sys;

-- Drop existing tables to avoid conflicts (optional)
DROP TABLE IF EXISTS holding, transaction, portfolio, stock, user, admin;

-- Create 'admin' table
CREATE TABLE admin (
    ad_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    role VARCHAR(20)
);

-- Create 'user' table
CREATE TABLE user (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(50) NOT NULL,
    phone VARCHAR(15),
    date_joined DATE
);

-- Create 'stock' table
CREATE TABLE stock (
    s_id INT AUTO_INCREMENT PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL UNIQUE,
    company_name VARCHAR(100) NOT NULL,
    sector VARCHAR(50),
    curr_price DECIMAL(10,2),
    market_cap DECIMAL(15,2)
);

-- Create 'portfolio' table
CREATE TABLE portfolio (
    p_id INT AUTO_INCREMENT PRIMARY KEY,
    p_name VARCHAR(50) NOT NULL,
    created_date DATE,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

-- Create 'holding' table
CREATE TABLE holding (
    h_id INT AUTO_INCREMENT PRIMARY KEY,
    p_id INT,
    s_id INT,
    qty INT,
    avg_buy_price DECIMAL(10,2),
    last_updated DATE,
    FOREIGN KEY (p_id) REFERENCES portfolio(p_id),
    FOREIGN KEY (s_id) REFERENCES stock(s_id)
);

-- Create 'transaction' table
CREATE TABLE transaction (
    t_id INT AUTO_INCREMENT PRIMARY KEY,
    p_id INT,
    s_id INT,
    transctn_type ENUM('BUY','SELL'),
    qty INT,
    price DECIMAL(10,2),
    date_time DATETIME,
    executed_by VARCHAR(50),
    FOREIGN KEY (p_id) REFERENCES portfolio(p_id),
    FOREIGN KEY (s_id) REFERENCES stock(s_id)
);

-- Insert sample data into 'admin'
INSERT INTO admin (email, name, password, role) VALUES
('admin1@mail.com', 'Admin One', 'pass123', 'SuperAdmin'),
('admin2@mail.com', 'Admin Two', 'pass456', 'Manager');

-- Insert sample data into 'user'
INSERT INTO user (name, email, password, phone, date_joined) VALUES
('Riya', 'riya@mail.com', 'riya123', '9876543210', '2025-09-01'),
('Arjun', 'arjun@mail.com', 'arjun123', '9876501234', '2025-09-02');

-- Insert sample data into 'stock'
INSERT INTO stock (symbol, company_name, sector, curr_price, market_cap) VALUES
('INFY', 'Infosys', 'IT Services', 1400.00, 5000000.00),
('RELI', 'Reliance Industries', 'Energy', 2400.00, 12000000.00);

-- Insert sample data into 'portfolio'
INSERT INTO portfolio (p_name, created_date, user_id) VALUES
('Riya_Portfolio', '2025-09-05', 1),
('Arjun_Portfolio', '2025-09-06', 2);

-- Insert sample data into 'holding'
INSERT INTO holding (p_id, s_id, qty, avg_buy_price, last_updated) VALUES
(1, 1, 10, 1400.00, '2025-09-10'),
(2, 2, 5, 2400.00, '2025-09-11');

-- Insert sample data into 'transaction'
INSERT INTO transaction (p_id, s_id, transctn_type, qty, price, date_time, executed_by) VALUES
(1, 1, 'BUY', 10, 1400.00, '2025-09-10 10:00:00', 'Riya'),
(2, 2, 'BUY', 5, 2400.00, '2025-09-11 14:30:00', 'Arjun');

-- Verify data
SELECT * FROM admin;
SELECT * FROM user;
SELECT * FROM stock;
SELECT * FROM portfolio;
SELECT * FROM holding;
SELECT * FROM transaction;
