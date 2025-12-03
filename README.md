# Global Supply Chain Control Tower: "Operationalizing Predictive Logistics through Cloud SQL, Machine Learning, and Enterprise BI"

## Introduction
In the complex web of global trade, supply chains have shifted from linear movements to dynamic, volatile networks. A single delayed shipment can cascade into production halts and stockouts, costing millions. Traditional reporting methods are retrospective, telling business leaders what went wrong yesterday rather than what will fail tomorrow.
The Global Supply Chain Control Tower is an end-to-end data intelligence system designed to solve this latency problem. Unlike static dashboards, this project engineers a closed-loop analytics ecosystem. It ingests high-volume data (73,000+ transactional records) into a Cloud MySQL Data Warehouse, processes it through a Python-based Machine Learning pipeline (Scikit-Learn) to predict delay probabilities, and writes those risk scores back into the database for real-time visualization.
Built for "Nexus Logistics," a fictional global distributor, this system moves beyond simple tracking. It leverages historical patterns, such as carrier performance, seasonal congestion, and route efficiency to flag "At-Risk" shipments before they leave the dock. This project demonstrates the convergence of Data Engineering, Data Science, and Business Intelligence to deliver a 360-degree view of operational health.

## Statement of the Business Problem
"Nexus Logistics" manages a quarterly volume of 73,000 shipments across 3 continents. Despite having abundant data, the operations team faces three critical failures:

1. The "Scale vs. Speed" Bottleneck: With transaction volumes exceeding 70,000 rows per quarter, Excel-based reporting crashes and fails to update in real-time. Manual data consolidation creates a 24-hour information lag, making "Real-Time" decision-making impossible.
- Business Impact: $450k lost annually in expedited shipping fees to compensate for late detection of delays.

2. Reactive vs. Predictive Blindness: The current system flags a shipment as "Late" only after the expected arrival date has passed. There is no capability to predict delays based on leading indicators (e.g., specific carrier reliability during holiday seasons).
- Business Impact: Customer satisfaction scores have dropped 15% due to an inability to provide proactive delay notifications.

3. The "Black Box" of Vendor Performance: Without a unified semantic layer, different departments calculate "On-Time Delivery" differently. Management lacks a standardized view to hold suppliers accountable or negotiate better rates based on actual performance data.

## Project Objectives
To address these operational gaps, the project aims to:

i.	Architect a Cloud-Scale Data Warehouse: Design and deploy a normalized MySQL 8.0 schema hosted on the cloud, capable of ingesting and querying 73,000+ rows with sub-second latency using advanced indexing and CLI-based bulk loading techniques.

ii.	Develop an ML "Early Warning" System: Engineer a Python-based Predictive Pipeline using scikit-learn (Random Forest Classifier) to analyze historical lead times and assign a "Delay Probability Score" (0-100%) to every active shipment.

iii.	Implement an Automated Write-Back Loop: Create a production-grade data flow where ML predictions are not just analyzed but written back into the live SQL database, enriching the operational data layer with future intelligence.

iv.	Construct a Semantic BI Model: Build a robust LookML data model to standardize complex KPIs (e.g., OTIF - On Time In Full, Supplier Risk Index) across the organization, ensuring a single source of truth.

v.	Deploy an Executive Control Tower: Design an interactive Looker Dashboard that integrates geospatial mapping and predictive alerts, allowing operations managers to filter shipments by "Predicted High Risk" rather than just current status.

## Tech Stack

### Infrastructure & Database

•	MySQL 8.0 (Cloud Hosted): Primary Data Warehouse.

•	MySQL CLI (Command Line Interface): Used for rapid schema deployment, database administration, and high-speed bulk data ingestion.

### Data Science & Machine Learning

•	Python 3.x: Core programming language for data generation and modeling.

•	Scikit-Learn: Library used to train the Random Forest Classifier for delay

•	Pandas/NumPy: Used for data manipulation and feature engineering.

•	SQLAlchemy: ORM used to handle the "Write-Back" of ML predictions to the MySQL database.

•	Faker: Used to generate realistic, high-volume synthetic datasets (73,000 rows).


### Business Intelligence

•	Google Looker: Enterprise BI platform for semantic modeling (LookML) and dashboard visualization.
DevOps & Tools

•	VS Code: Integrated Development Environment for SQL and Python scripts.

## Project Implementation Steps

### PHASE 1: INFRASTRUCTURE & DATA PIPELINE

This step establishes the core infrastructure by provisioning a secure, cloud-hosted MySQL 8.0 instance designed for enterprise scalability. By configuring firewall rules to whitelist only the developer's local IP address, the system ensures authorized CLI access for high-speed data ingestion while remaining impenetrable to external public threats.

•	Run the below command in your terminal to download mysql.
```
sudo apt update
sudo apt install mysql-server -y
```

•	To confirm mysql has been installed, run this command to check the version
```
mysql --version
``` 
<img width="975" height="137" alt="image" src="https://github.com/user-attachments/assets/c2beb589-7386-482a-a4be-021948e66236" />


•	Let us start enable and check the status of mysql. Run these commands one by one
```
sudo systemctl start mysql
sudo systemctl enable mysql
sudo systemctl status mysql
 ```
<img width="974" height="257" alt="image" src="https://github.com/user-attachments/assets/607c42bb-c68b-4af1-8f86-8ffed68adbae" />


•	First, we need to set the root password and remove insecure defaults. Ubuntu includes a script just for this. Run this command in your terminal:
```
sudo mysql_secure_installation
```

•	We need to create a new user in the MySQL server. Run the command to enter mysql
```
sudo mysql
```
<img width="975" height="403" alt="image" src="https://github.com/user-attachments/assets/bedc4a5e-9865-4db1-a286-a2ae9a736183" />


•	Create the nexus database. Run
```
CREATE DATABASE nexus_db;
```
<img width="559" height="161" alt="image" src="https://github.com/user-attachments/assets/6f6d576d-b8ae-459d-98a3-dd3da66e1372" />


•	Create a new user and password Replace your_password with a strong password.
```
CREATE USER 'nexus_user'@'localhost' IDENTIFIED BY 'your_password';
```

•	Grant full access to the user This allows nexus_user to read/write only to nexus_db
```
GRANT ALL PRIVILEGES ON nexus_db.* TO 'nexus_user'@'localhost';
```

•	Save changes and exit. Run
```
FLUSH PRIVILEGES;
EXIT;
```

•	Verify it works. Now, try to log in using the new user you just created to make sure the permissions are correct:
```
mysql -u nexus_user -p
```
<img width="975" height="417" alt="image" src="https://github.com/user-attachments/assets/444873ea-1fca-4c69-bf31-31aefa8e73f8" />


### Step 2: Develop a Python script using Faker and Pandas to generate 73,000 rows of synthetic supply chain data, injecting realistic patterns like "holiday surges" and specific supplier delay tendencies.

In this step, we transition from infrastructure setup to data simulation, generating the critical "raw material" needed to power our analytical ecosystem. Since we cannot access proprietary data from a real logistics firm, we will leverage Python alongside the Faker and Pandas libraries to engineer a high-fidelity dataset of 73,000 shipment records. This process goes beyond generating random noise; we will programmatically inject specific statistical patterns, such as increased latency during holiday months and performance degradations for specific carriers to ensure the data mimics real-world volatility. This step is foundational, as it creates the necessary historical "signals" that our Machine Learning model will later learn to detect, transforming an empty database into a rich training ground for predictive logistics.

•	We need a Python virtual environment (venv) to keep each project’s packages separate so they don’t conflict with other projects or with your system Python. Run the commands;
```
sudo apt install python3-venv -y
python3 -m venv venv
source venv/bin/activate
```

We would Install Required Python Libraries (pandas, faker and numpy)

o	Pandas is a Python library used for fast, flexible, and powerful data analysis and manipulation using DataFrames.

o	Faker is a Python library that generates realistic fake data such as names, emails, addresses, and phone numbers for testing or development.

o	NumPy is a Python library that provides high-performance numerical computing and supports large multi-dimensional arrays and mathematical operations.


•	Run the below python command to install pandas, faker and numpy
```
sudo apt install python3-pip -y 
pip3 install pandas faker numpy
``` 
<img width="975" height="337" alt="image" src="https://github.com/user-attachments/assets/c42e2d19-8b28-4ed0-b9fb-372aa548bdae" />


•	Create a specific folder for your data generation scripts. Run;
```
mkdir -p ~/projects/Nexus-Supply-Chain/data_generation
cd ~/projects/Nexus-Supply-Chain/data_generation
```

•	Create a python file named generate_data.py and paste the below code in it;
```
import pandas as pd
import numpy as np
from faker import Faker
import random
from datetime import timedelta, datetime

# Initialize Faker and Seed for reproducibility
fake = Faker()
Faker.seed(42)
random.seed(42)

# Configuration
NUM_ROWS = 73000
CARRIERS = ['Nexus Air', 'Global Cargo', 'FastTrack Logistics', 'Oceanic Freight', 'Rapid Move']
PRODUCTS = ['Laptop', 'Smartphone', 'Industrial Monitor', 'Circuit Board', 'Server Rack']
ORIGINS = ['Shenzhen', 'Mumbai', 'Hamburg', 'Los Angeles', 'Tokyo']
DESTINATIONS = ['New York', 'London', 'Berlin', 'Toronto', 'Chicago']

data = []

print(f"Generating {NUM_ROWS} records. This may take a moment...")

for _ in range(NUM_ROWS):
    # 1. Basic Shipment Details
    ship_date = fake.date_between(start_date='-2y', end_date='today')
    carrier = random.choice(CARRIERS)
    origin = random.choice(ORIGINS)
    
    # 2. Calculate Expected Lead Time (randomized base efficiency)
    base_transit_days = random.randint(5, 20)
    expected_arrival_date = ship_date + timedelta(days=base_transit_days)
    
    # 3. PATTERN INJECTION: SIMULATE REAL WORLD CHAOS
    delay_days = 0
    
    # Pattern A: Holiday Surge (Nov/Dec shipments are slower)
    if ship_date.month in [11, 12]:
        if random.random() < 0.40: # 40% chance of delay during holidays
            delay_days += random.randint(2, 5)
            
    # Pattern B: "FastTrack Logistics" is actually terrible (Vendor Risk)
    if carrier == 'FastTrack Logistics':
        if random.random() < 0.35: # 35% chance of delay for this specific carrier
            delay_days += random.randint(3, 7)
            
    # Pattern C: Random operational hiccups (Weather, Customs) - Rare
    if random.random() < 0.05:
        delay_days += random.randint(1, 10)

    # 4. Calculate Actual Arrival
    actual_arrival_date = expected_arrival_date + timedelta(days=delay_days)
    
    # 5. Determine Status
    is_late = 1 if actual_arrival_date > expected_arrival_date else 0
    status = "Late" if is_late else "On Time"

    # 6. Append to list
    data.append({
        'tracking_number': fake.uuid4(),
        'customer_name': fake.company(),
        'product': random.choice(PRODUCTS),
        'quantity': random.randint(1, 1000),
        'weight_kg': round(random.uniform(10.0, 500.0), 2),
        'carrier': carrier,
        'origin': origin,
        'destination': random.choice(DESTINATIONS),
        'ship_date': ship_date,
        'expected_arrival_date': expected_arrival_date,
        'actual_arrival_date': actual_arrival_date,
        'shipping_cost': round(random.uniform(100.0, 5000.0), 2),
        'status': status,
        'is_late': is_late,  # Target variable for ML
        'delay_risk_score': 0.0 # Placeholder for later ML prediction
    })

# Create DataFrame
df = pd.DataFrame(data)

# Save to CSV
csv_filename = "supply_chain_data.csv"
df.to_csv(csv_filename, index=False)

print(f"Success! Generated {len(df)} rows.")
print(f"Data saved to: {csv_filename}")
print(f"Preview:\n{df.head(3)}")
```

#### What this code does:

i.	Faker: Creates fake addresses, names, and dates.

ii.	Logic: It simulates 73,000 shipments.

iii.	Pattern Injection: It specifically forces shipments in November/December to be late more often (Holiday Surge) and makes one specific carrier ("FastTrack Logistics") unreliable, so your ML model can detect these trends later.


•	Run the below command to generate the data
```
python3 generate_data.py
```
<img width="975" height="238" alt="image" src="https://github.com/user-attachments/assets/3f07a675-0f9f-4400-91a1-265ca30230ce" />


### Step 3: Write the build_schema.sql script to define the Star Schema architecture, including Primary Keys, Foreign Keys, and the new predicted_delay_risk column.

In this step, we switch from generating data to building the home for it. We need to tell MySQL exactly how to organize the 73,000 shipment records we just created. To do this, we will write a SQL script named build_schema.sql that defines the table structure.

This script is critical for two reasons:

i.	Strict Rules: Unlike Excel, MySQL needs to know exactly what kind of data goes into every column (e.g., ensuring "Dates" are dates and "Weights" are numbers) so it doesn't crash later.

ii.	Future-Proofing for AI: We will purposefully create an empty column called predicted_delay_risk. This column will stay empty for now, but it reserves the specific spot where our Machine Learning model will write its predictions in Phase 3


•	Create a file named build_schema.sql in the main project folder and paste the below script.
```
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
```

This script tells MySQL how to build the Shipments Table. It enforces three main rules:

i.	Unique IDs: Every tracking_number must be unique (no duplicates allowed).

ii.	Correct Math: It forces shipping_cost and weight to be treated as numbers, not text.

iii.	Future-Proofing: It creates a special empty column (delay_risk_score) that doesn't exist in your CSV yet. This is the "reserved seat" where your AI will write its predictions later.


### Step 4: Execute the schema build script via the MySQL Command Line Interface (CLI) to construct the database structure.

In this step, we turn our "Blueprint" into reality. Currently, our build_schema.sql file is just a text document sitting on our hard drive. The MySQL database doesn't know it exists yet. In this step, we will use the MySQL Command Line Interface (CLI) to "feed" this script into the database server.
Think of this as handing the blueprints to the construction crew. When we run the command, MySQL will read our file line-by-line and physically build the empty shipments table inside the system. By the end of this step, our database will have a fully structured, empty table waiting to receive our data.

•	Execute the Blueprint by running the command;
```
mysql -u nexus_user -p < build_schema.sql
```

•	To make sure the table was actually created, run this command to "peek" inside the database
```
mysql -u nexus_user -p -e "DESCRIBE nexus_db.shipments;"
```
<img width="975" height="400" alt="image" src="https://github.com/user-attachments/assets/661e89eb-c51b-47d3-ae70-00f120ae3fad" />
 

### Step 5: Perform high-volume bulk ingestion using the LOAD DATA LOCAL INFILE command via CLI to populate tables from CSVs in under 5 seconds.

In this final infrastructure step of phase 1, we populate our empty shipments table with the 73,000 records we generated earlier. Instead of inserting rows one by one which is slow and inefficient, we will use the enterprise-grade command LOAD DATA LOCAL INFILE. This command is designed for high-performance data warehousing; it bypasses standard processing overhead to read the raw CSV file directly from our disk and stream it into the database columns instantly. By the end of this step, our database will go from an empty shell to a fully populated Data Warehouse containing 73,000 searchable records, ready for analysis.

•	By default, MySQL blocks you from reading files off the hard drive for security reasons. We need to enable the local_infile setting globally. Run this command;
```
sudo mysql -e "SET GLOBAL local_infile=1;"
```

•	Run this entire block in your terminal
```
mysql --local-infile=1 -u nexus_user -p nexus_db -e "
LOAD DATA LOCAL INFILE 'data_generation/supply_chain_data.csv'
INTO TABLE shipments
FIELDS TERMINATED BY ','
ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(tracking_number, customer_name, product, quantity, weight_kg, carrier, origin, destination, ship_date, expected_arrival_date, actual_arrival_date, shipping_cost, status, is_late, delay_risk_score);"
```

•	Verify the Count. If it worked, it should finish instantly. Let's count the rows to make sure all 73,000 made it in. Run;
```
mysql -u nexus_user -p -e "SELECT COUNT(*) FROM nexus_db.shipments;"
``` 
<img width="975" height="354" alt="image" src="https://github.com/user-attachments/assets/5f60c5ed-d1f5-4f0d-8dcb-9b12f15e4980" />

### PHASE 2: SQL ENGINEERING & LOGIC

### Step 1: Implement database indexing on high-cardinality columns (tracking_number, product_id) to ensure sub-second query response times on the 73k dataset

In this step, we are shifting focus from Functionality (making it work) to Performance (making it fast). Right now, if you search for a single tracking number, MySQL has to perform a "Full Table Scan," meaning it reads every single one of the 73,000 rows to find the match. As data grows, this becomes incredibly slow.

We will implement Database Indexing on high-cardinality columns like tracking_number and product. Think of an index like the alphabetical index at the back of a textbook; instead of reading every page to find a topic, the database can flip directly to the exact row. By adding these indexes, we ensure that even with 73,000+ records, our query response times remain sub-second, which is critical for the real-time dashboard we will build later.

•	Create the Indexing Script named add_indexes.sql in the main project folder and paste the below;
```
USE nexus_db;

-- 1. Optimize Product Searches
-- Speeds up queries like: "Show me all Laptops"
CREATE INDEX idx_product ON shipments(product);

-- 2. Optimize Carrier Performance Analysis
-- Critical for calculating "Average Vendor Lead Time" later
CREATE INDEX idx_carrier ON shipments(carrier);

-- 3. Optimize Date Ranges
-- Speeds up: "Show me shipments from November"
CREATE INDEX idx_ship_date ON shipments(ship_date);

-- 4. Optimize Status Filtering
-- Speeds up: "Show me all Late shipments"
CREATE INDEX idx_status ON shipments(status);
```

•	Run this command to apply the new rules to your database:
```
mysql -u nexus_user -p < add_indexes.sql
```

•	Let's confirm the indexes are actually there. Run this command:
```
mysql -u nexus_user -p -e "SHOW INDEX FROM nexus_db.shipments;"
```
<img width="975" height="352" alt="image" src="https://github.com/user-attachments/assets/b0135be7-6c9d-4eb1-8640-c542c76098d8" />


### Step 2: Develop SQL Stored Procedures to automate inventory adjustments and flag "High Value" shipments based on cost thresholds.

In this step, we are teaching the database to manage itself. Right now, your data is "dumb". It just sits there. If a shipment costs $5,000, the database doesn't treat it differently than a $10 shipment. We will change that by writing a Stored Procedure (a saved automation script) named CategorizeHighValue.

#### What this automation will do:

i.	Modify the Table: First, it will add a new column called value_tier to your table (since we didn't add it originally).

ii.	Scan & Flag: It will automatically scan all 73,000 rows.

iii.	Apply Logic: If a shipment's shipping cost is over $2,000, it will stamp it as "High Value". If it's less, it stamps it as "Standard".

This allows management to instantly filter for high-risk, high-value cargo without manually calculating costs in Excel.


•	Create the Procedure Script named setup_procedures.sql and paste the below in it;
```
USE nexus_db;

-- 1. Add the new column to store our tags (if it doesn't exist)
-- We use a safe check to avoid errors if you run it twice
SET @dbname = DATABASE();
SET @tablename = "shipments";
SET @columnname = "value_tier";
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE
      (table_name = @tablename)
      AND (table_schema = @dbname)
      AND (column_name = @columnname)
  ) > 0,
  "SELECT 1",
  "ALTER TABLE shipments ADD COLUMN value_tier VARCHAR(20)"
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- 2. Drop the procedure if it exists (Clean Slate)
DROP PROCEDURE IF EXISTS FlagHighValueShipments;

-- 3. Create the Automation Routine
DELIMITER //

CREATE PROCEDURE FlagHighValueShipments()
BEGIN
    -- Flag Expensive Shipments (> $2000)
    UPDATE shipments 
    SET value_tier = 'High Value' 
    WHERE shipping_cost > 2000;

    -- Flag Standard Shipments (<= $2000)
    UPDATE shipments 
    SET value_tier = 'Standard' 
    WHERE shipping_cost <= 2000 OR shipping_cost IS NULL;
    
    SELECT 'Success: Shipments have been categorized.' AS Status_Message;
END //

DELIMITER ;
```

•	Now, load this logic into the database. Run;
```
mysql -u nexus_user -p < setup_procedures.sql
```

Now that the "mini-program" is saved in the database, let's run it to actually update your 73,000 rows. Run;
```
mysql -u nexus_user -p -e "CALL nexus_db.FlagHighValueShipments();"
```
<img width="975" height="166" alt="image" src="https://github.com/user-attachments/assets/d5adf174-ae3e-4055-aae9-15c841cf9309" />
 

•	Let's check if it worked. We will ask the database to count how many "High Value" shipments we have. Run;
```
mysql -u nexus_user -p -e "SELECT value_tier, COUNT(*) FROM nexus_db.shipments GROUP BY value_tier;"
```
<img width="975" height="200" alt="image" src="https://github.com/user-attachments/assets/997bed70-9b00-4f4e-a3d9-06252a219640" />
 

### Step 3: Construct a master SQL View (vw_ml_training_data) that joins Fact and Dimensions to flatten the data specifically for the Python Machine Learning model.

In this step, we bridge the gap between SQL (Data Storage) and Python (Data Science). Machine Learning models are picky. They do not want "noise" like Customer Names or internal IDs (tracking_number), and they cannot read raw tables efficiently if you are constantly changing columns. They need a clean, consistent dataset.
We will create a SQL View named vw_ml_training_data. Think of a "View" as a Virtual Table. It does not store data itself; instead, it runs a saved query every time you access it.

#### Why this is critical:

i.	Filtering: It will strictly select only the columns relevant for prediction (e.g., carrier, origin, ship_date, is_late), ignoring "noise" like customer_name.

ii.	Protection: It creates an abstraction layer. If you change your main table structure later, you only fix the View, and your Python ML script (which we build in Phase 3) never breaks.


•	Create a new file named create_view.sql in your main project folder.
```
USE nexus_db;

-- 1. Clean Slate
DROP VIEW IF EXISTS vw_ml_training_data;

-- 2. Create the Virtual Table
CREATE VIEW vw_ml_training_data AS
SELECT 
    carrier,
    origin,
    destination,
    -- Extract specific time features for the AI to learn from
    MONTH(ship_date) as ship_month,
    DAYOFWEEK(ship_date) as ship_day_of_week,
    shipping_cost,
    value_tier,
    -- The Answer Key (Target Variable)
    is_late
FROM 
    shipments;
```

•	Run this command to save the view definition in the database.
```
mysql -u nexus_user -p < create_view.sql
```

•	Let's look at the data through the eyes of the Machine Learning model. Run
```
mysql -u nexus_user -p -e "SELECT * FROM nexus_db.vw_ml_training_data LIMIT 5;"
```
<img width="975" height="233" alt="image" src="https://github.com/user-attachments/assets/a6c07936-c11c-4cb4-93de-d45993a2c926" />
 
### Step 4: Write Window Functions to calculate historical "Average Vendor Lead Time," which serves as a critical feature input for the ML model.

In this step, we will calculate Historical Context. Right now, if you look at a row, you know that specific shipment was late. But the AI needs to know: "Is this carrier usually late?"
We will write a query using Window Functions to calculate the Average Vendor Lead Time. Unlike a standard GROUP BY which squashes rows together, a Window Function allows us to keep all 73,000 rows while adding a new column that says "On average, this carrier takes 12.5 days." This is a powerful "Feature" that improves the accuracy of prediction models significantly.

•	Create a new file named feature_engineering.sql in your main project folder and paste the below.
```
USE nexus_db;

-- Create a View that creates "Smart Features" for our Analysis
CREATE OR REPLACE VIEW vw_carrier_performance AS
SELECT 
    tracking_number,
    carrier,
    origin,
    destination,
    is_late,
    
    -- 1. How long did THIS shipment take? (Raw Data)
    DATEDIFF(actual_arrival_date, ship_date) as actual_days_taken,
    
    -- 2. What is the AVERAGE time this Carrier takes? (Window Function)
    -- This looks at the entire history of the carrier
    AVG(DATEDIFF(actual_arrival_date, ship_date)) 
        OVER (PARTITION BY carrier) as carrier_avg_lead_time,

    -- 3. Compare this shipment to the Carrier's Average
    (DATEDIFF(actual_arrival_date, ship_date) - 
        AVG(DATEDIFF(actual_arrival_date, ship_date)) OVER (PARTITION BY carrier)) 
        as diff_from_avg
FROM 
    shipments;
```

•	Run this command to save this smart logic into the database.
```
mysql -u nexus_user -p < feature_engineering.sql
```

•	Let's see if the database is now calculating averages on the fly.
```
mysql -u nexus_user -p -e "SELECT carrier, actual_days_taken, carrier_avg_lead_time FROM nexus_db.vw_carrier_performance LIMIT 10;"
``` 
<img width="975" height="371" alt="image" src="https://github.com/user-attachments/assets/029a24fc-d742-47f3-9a68-0b56b30b0e5c" />


