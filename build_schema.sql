-- 1. Create the Database (if it doesn't exist yet)
CREATE DATABASE IF NOT EXISTS nexus_db;
USE nexus_db;

-- 2. Clean slate: Remove the table if it already exists
DROP TABLE IF EXISTS shipments;

-- 3. Define the Table Structure (The Blueprint)
CREATE TABLE shipments (
    tracking_number VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100),
    product VARCHAR(50),
    quantity INT,
    weight_kg DECIMAL(10,2),
    carrier VARCHAR(50),
    origin VARCHAR(50),
    destination VARCHAR(50),
    ship_date DATE,
    expected_arrival_date DATE,
    actual_arrival_date DATE,
    shipping_cost DECIMAL(10,2),
    status VARCHAR(20),
    is_late TINYINT,      -- 0 for On Time, 1 for Late
    delay_risk_score DECIMAL(5,4)  -- The empty seat for AI predictions
);