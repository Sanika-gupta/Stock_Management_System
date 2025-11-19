USE stock_mgmt_sys;
-- Trigger to ensure transaction date validity
-- ========================================
DELIMITER //
CREATE TRIGGER check_transaction_date
BEFORE INSERT ON transaction
FOR EACH ROW
BEGIN
    IF NEW.date_time < CURRENT_DATE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transaction date cannot be earlier than today';
    END IF;
END;
//
DELIMITER ;

-- Add dividend column to stock table
-- ========================================
ALTER TABLE stock ADD COLUMN dividend DECIMAL(10,2) DEFAULT 0;


-- Function to calculate total dividend for a holding
-- ========================================
DELIMITER //
CREATE FUNCTION calc_holding_dividend(h_qty INT, s_id_in INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE div_per_share DECIMAL(10,2);
    SELECT dividend INTO div_per_share FROM stock WHERE s_id = s_id_in;
    RETURN h_qty * div_per_share;
END;
//
DELIMITER ;

-- Add cash_balance column to portfolio
-- ========================================
ALTER TABLE portfolio ADD COLUMN cash_balance DECIMAL(12, 2) DEFAULT 0.00;


-- Stored Procedure to distribute dividends
-- ========================================
DELIMITER //
CREATE PROCEDURE distribute_dividends(IN p_id_in INT)
BEGIN
    DECLARE v_total_dividend DECIMAL(12, 2);
    DECLARE v_user_id INT; 
    DECLARE v_executed_by VARCHAR(50);
    
    START TRANSACTION;
    
    SELECT SUM(h.qty * s.dividend) INTO v_total_dividend
    FROM holding h
    JOIN stock s ON h.s_id = s.s_id
    WHERE h.p_id = p_id_in;

    SELECT p.user_id, u.name INTO v_user_id, v_executed_by
    FROM portfolio p
    JOIN user u ON p.user_id = u.user_id
    WHERE p.p_id = p_id_in;

    IF v_total_dividend IS NOT NULL AND v_total_dividend > 0 THEN
        UPDATE portfolio
        SET cash_balance = cash_balance + v_total_dividend
        WHERE p_id = p_id_in;
        
        INSERT INTO transaction (p_id, s_id, transctn_type, qty, price, date_time, executed_by)
        VALUES (p_id_in, NULL, 'DIVIDEND', 0, v_total_dividend, NOW(), v_executed_by);
        
        COMMIT;
        SELECT CONCAT('SUCCESS: Dividend of $', v_total_dividend, ' distributed to ', v_executed_by, '.') AS Status;
    ELSE
        ROLLBACK;
        SELECT 'FAILED: Distribution aborted or zero dividend calculated.' AS Status;
    END IF;
END;
//
DELIMITER ;

-- Data updates and test queries
-- ========================================
UPDATE stock SET dividend = 2.00 WHERE s_id = 1;
UPDATE stock SET dividend = 4.00 WHERE s_id = 2;

ALTER TABLE transaction MODIFY COLUMN transctn_type ENUM('BUY','SELL','DIVIDEND');

SELECT cash_balance FROM portfolio WHERE p_id = 1;
SELECT COUNT(*) FROM transaction WHERE p_id = 1;

CALL distribute_dividends(1);

SELECT cash_balance FROM portfolio WHERE p_id = 1;
SELECT COUNT(*) FROM transaction WHERE p_id = 1;

SELECT t_id, transctn_type, price, executed_by 
FROM transaction 
WHERE p_id = 1 
ORDER BY t_id DESC LIMIT 1;


--TRIGGER TO MAKE SURE ENOUGH CASH BALANCE IS THERE BEFORE ANY TRANSACTION
-- ========================================

DELIMITER //
CREATE TRIGGER check_cash_balance_before_buy
BEFORE INSERT ON transaction
FOR EACH ROW
BEGIN
    DECLARE v_balance DECIMAL(12,2);
    DECLARE v_cost DECIMAL(12,2);
    DECLARE v_message VARCHAR(255);

    IF NEW.transctn_type = 'BUY' THEN
        SELECT cash_balance INTO v_balance FROM portfolio WHERE p_id = NEW.p_id;
        SET v_cost = NEW.qty * NEW.price;

        IF v_balance < v_cost THEN
            SET v_message = CONCAT('Insufficient balance: Available Rs ', v_balance, ', Required Rs ', v_cost);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_message;
        END IF;
    END IF;
END;
//
DELIMITER ;