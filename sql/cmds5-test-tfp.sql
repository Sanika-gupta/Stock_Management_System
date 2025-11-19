USE stock_mgmt_sys;

---------------------------------------------------------
-- TESTING THE FUNCTION : calc_holding_dividend()
---------------------------------------------------------

-- Check stock dividend values
SELECT s_id, symbol, company_name, dividend 
FROM stock;

-- Calculate dividend for holding *your actual holdings*
-- For example Riya holds:
-- (use holdings you actually have)
SELECT 
    h.h_id,
    h.p_id,
    s.symbol,
    h.qty,
    s.dividend,
    calc_holding_dividend(h.qty, h.s_id) AS total_dividend
FROM holding h
JOIN stock s ON h.s_id = s.s_id
WHERE h.p_id = 1;   -- Change p_id to test others

---------------------------------------------------------
-- TESTING THE PROCEDURE : distribute_dividends()
---------------------------------------------------------

-- 1) Cash balance BEFORE
SELECT p_id, p_name, cash_balance 
FROM portfolio 
WHERE p_id = 1;   -- Riya Portfolio

-- 2) Execute procedure
CALL distribute_dividends(1);   -- Distribute to Riya

-- 3) Cash balance AFTER distribution (should increase)
SELECT p_id, p_name, cash_balance 
FROM portfolio 
WHERE p_id = 1;

-- 4) Check transaction entry created with type = DIVIDEND
SELECT t_id, p_id, transctn_type, qty, price, date_time, executed_by
FROM transaction
WHERE p_id = 1
ORDER BY t_id DESC
LIMIT 5;


---------------------------------------------------------
-- TESTING THE BUY BALANCE CHECK TRIGGER
-- (Trigger: check_cash_balance_before_buy)
---------------------------------------------------------

-- First check Arjun’s balance (p_id = 2 for you):
SELECT p_id, p_name, cash_balance 
FROM portfolio 
WHERE p_id = 2;

-- Try a buy Arjun CANNOT afford (Should FAIL & show Trigger message)
INSERT INTO transaction (p_id, s_id, transctn_type, qty, price, date_time, executed_by)
VALUES (2, 1, 'BUY', 5, 5000, NOW(), 'Arjun');

-- Expected Output:
-- ERROR: Insufficient balance: Available Rs X, Required Rs Y


---------------------------------------------------------
-- TESTING A SUCCESSFUL BUY (if enough balance exists)
---------------------------------------------------------

INSERT INTO transaction (p_id, s_id, transctn_type, qty, price, date_time, executed_by)
VALUES (2, 3, 'BUY', 1, 269.05, NOW(), 'Arjun');

-- Now update holding table manually or keep update in your backend logic
-- But if demonstrating manually:
UPDATE portfolio 
SET cash_balance = cash_balance - (1 * 269.05)
WHERE p_id = 2;

-- Show updated balance
SELECT p_id, p_name, cash_balance 
FROM portfolio WHERE p_id = 2;


---------------------------------------------------------
-- TESTING SELL
---------------------------------------------------------

INSERT INTO transaction (p_id, s_id, transctn_type, qty, price, date_time, executed_by)
VALUES (1, 2, 'SELL', 1, 1471.10, NOW(), 'Riya');

-- Update Riya’s cash balance (manual for demo)
UPDATE portfolio 
SET cash_balance = cash_balance + 1471.10
WHERE p_id = 1;

SELECT p_id, p_name, cash_balance 
FROM portfolio WHERE p_id = 1;
