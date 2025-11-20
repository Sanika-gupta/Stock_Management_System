# Stock Management System (Flask + MySQL)

A full-stack DBMS project with SQL schema, Flask backend, and web interface for managing stocks, portfolios, and transactions.

## Features 
### User Features

- User login & registration
- View portfolio & holdings
- Buy/Sell stocks
- Auto-updated cash balance

### Admin Features

- Admin login
- Add/Edit stock details
- Update price, market-cap, dividend
- View all users & portfolios

### Database Features

- SQL Triggers
- Stored Procedures
- SQL Functions
- Joins, Nested Queries, Aggregates
- Role-based MySQL privileges
- Cascading foreign keys
- Organized relational schema

## Tech Stack

| Layer    | Technology                             |
| -------- | -------------------------------------- |
| Backend  | Flask (Python)                         |
| Frontend | HTML, CSS, Jinja Templates             |
| Database | MySQL                                  |
| SQL      | Triggers, Procedures, Functions, Joins |
| Tools    | MySQL Workbench, VS Code               |


## Installation / Setup Instructions
### 1. Import SQL files into MySQL
   - Run cmds1-create-tables.sql
   - Then cmds2-alter.sql
   - Then cmds3-trigg-proced-func.sql
   - ️Then cmds4-user-admin-priv.sql        --> creates MySQL users + privileges  
   - Then cmds5-test-tfp.sql               --> testing queries for triggers & procedures  


### 2. Create virtual environment
   - python -m venv venv
   - source venv/bin/activate   (Mac/Linux)
   - venv\Scripts\activate      (Windows)

### 3. Install dependencies
   pip install -r requirements.txt

### 4. Update config.py
  -  DB_HOST     = "localhost"
  -  DB_USER     = "root"
  -  DB_PASSWORD = "your_mysql_password"
  -  DB_NAME     = "stock_mgmt_sys"


### 5. Run the app:
   - python app.py
   - => open http://localhost:5000

## UI Overview
- User overview
<img width="2806" height="1279" alt="riya-portfolio" src="https://github.com/user-attachments/assets/6568837d-bc74-4524-b882-e35c763d1261" />

- Admin dashboard  
<img width="2799" height="1269" alt="admin-ss-1" src="https://github.com/user-attachments/assets/65b15b85-c70f-4ae9-b321-9158ea9e6423" />




## How the System Works (Short Summary)

- When a new user signs up, the system creates a personal portfolio for them. They can check the list of available stocks and choose what they want to buy or sell.
- During a buy, the database automatically checks whether the user has enough balance.If the amount is sufficient, the transaction is recorded and the user’s holdings are updated.
- During a sell, the details are stored in the transaction table and the cash balance increases accordingly.
- Administrators can update stock details and set dividend values. When they run the dividend distribution procedure, the system calculates the dividend for each holding and credits it to the user’s portfolio.
- Throughout the process, the database handles most of the validation through triggers, constraints, and stored procedures, ensuring the data stays accurate and consistent.
   
## Contributors 

- Sanika Gupta
- Saanvi Kakkar
