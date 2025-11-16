# Stock Management System (Flask + MySQL)

A full-stack DBMS project with SQL schema, Flask backend, and web interface for managing stocks, portfolios, and transactions.

## Features 
- User & Admin login
- Portfolio management
- Holdings & transaction tracking
- SQL triggers, procedures & functions
- Flask backend with templated frontend
- MySQL database integration

## Installation / Setup Instructions
### 1. Import SQL files into MySQL
   - Run cmds1-create-tables.sql
   - Then cmds2-alter.sql
   - Then cmds3-trigg-proced-func.sql

### 2. Create virtual environment
   python -m venv venv
   source venv/bin/activate   (Mac/Linux)
   venv\Scripts\activate      (Windows)

### 3. Install dependencies
   pip install -r requirements.txt

### 4. Update config.py
   Set DB_USERNAME / PASSWORD as needed

### 5. Run the app:
   python app.py
   => open http://localhost:5000
