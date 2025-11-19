--FOR ADDING PRIVILEGES FOR ADMIN AND USER
-- creating 2 users for separate admin access and user access
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'adminpass';
CREATE USER 'normal_user'@'localhost' IDENTIFIED BY 'userpass';
--granting all privileges to admin
GRANT ALL PRIVILEGES ON stock_mgmt_sys.* TO 'admin_user'@'localhost';
--granting partial priviliges to the user 
GRANT SELECT, INSERT, UPDATE ON stock_mgmt_sys.transaction TO 'normal_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON stock_mgmt_sys.holding TO 'normal_user'@'localhost';
GRANT SELECT ON stock_mgmt_sys.stock TO 'normal_user'@'localhost';
GRANT SELECT, UPDATE ON stock_mgmt_sys.portfolio TO 'normal_user'@'localhost';
GRANT SELECT ON stock_mgmt_sys.user TO 'normal_user'@'localhost';

FLUSH PRIVILEGES;
-- TESTING the granted priviliges 
-- in a terminal for admin with pwd--> adminpass
mysql -u admin_user -p

--testing admin priviliges by updating stock prices 
USE stock_mgmt_sys;
UPDATE stock SET curr_price = 1500 WHERE s_id = 1;

--checking user priviliges in new cmd pwd-->userpass
mysql -u normal_user -p
-- trying to edit stock price we will get error as user
USE stock_mgmt_sys;
UPDATE stock SET curr_price = 1500 WHERE s_id = 1;
-- but things like insert will work fine for user 
INSERT INTO transaction (p_id, s_id, transctn_type, qty, price, date_time, executed_by)
VALUES (1, 1, 'BUY', 2, 1480, NOW(), 'Riya');