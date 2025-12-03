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

### PHASE 3: PREDICTIVE ANALYTICS (PYTHON + SCIKIT-LEARN)
### Step 1: Develop a Python "Fetcher" script that connects to the MySQL Cloud instance and extracts the training dataset into a Pandas DataFrame.

In this step, we are physically bridging the gap between our Data Warehouse (MySQL) and our Data Science Environment (Python).
Currently, our clean, engineered data is sitting safely inside the MySQL view vw_ml_training_data we built in Phase 2. However, our Machine Learning model cannot "see" inside the database directly. It needs the data to be loaded into the computer's active memory (RAM).

We will write a robust Python script named db_connector.py. This script acts as a secure tunnel. It will:

i.	Connect: Use a library called SQLAlchemy to authenticate with your MySQL database.

ii.	Extract: Query the specific "clean" view we created earlier.

iii.	Transform: Convert that raw SQL data into a Pandas DataFrame; a spreadsheet-like format that Python libraries like Scikit-Learn can understand and process instantly.

By the end of this step, we would have a reusable tool that pulls fresh training data with a single command.

•	Run this command inside your terminal to download SQLAlchemy: the tool that manages the connection "engine"
```
pip install sqlalchemy pymysql
```

•	Let's keep your Machine Learning logic separate from the data generation scripts. Run these commands;
```
cd /projects/Nexus-Supply-Chain
mkdir ml_pipeline
cd ml_pipeline
```

•	Create a new file named db_connector.py and paste the below script in it.
```
import pandas as pd
from sqlalchemy import create_engine
import pymysql
from urllib.parse import quote_plus  # <--- NEW IMPORT

# 1. Database Connection Details
DB_USER = 'nexus_user'
DB_PASSWORD = 'YOUR_PASSWORD'  # Your password with the special character
DB_HOST = 'localhost'
DB_NAME = 'nexus_db'

def get_training_data():
    """
    Connects to MySQL and fetches the clean training data.
    Returns: Pandas DataFrame
    """
    print("Step 1: Connecting to Database...")

    # --- THE FIX IS HERE ---
    # We encode the password to handle special characters like '@'
    encoded_password = quote_plus(DB_PASSWORD)

    # Use the encoded password in the connection string
    connection_string = f"mysql+pymysql://{DB_USER}:{encoded_password}@{DB_HOST}/{DB_NAME}"

    engine = create_engine(connection_string)

    # 2. Query the View we created in Phase 2
    query = "SELECT * FROM vw_ml_training_data;"

    print("Step 2: Executing Query...")

    # 3. Load into Pandas
    df = pd.read_sql(query, engine)

    print(f"Success! Loaded {len(df)} rows.")
    return df

# Test the function if this script is run directly
if __name__ == "__main__":
    try:
        df = get_training_data()
        print("\n--- Data Preview ---")
        print(df.head())
        print("\n--- Data Types ---")
        print(df.dtypes)
    except Exception as e:
        print(f"Error: {e}")
```


•	Run the script to make sure it can actually pull data from your database.
```
python db_connector.py
``` 
<img width="975" height="411" alt="image" src="https://github.com/user-attachments/assets/6625e480-86e5-4fe0-b465-7d55de2cf0fd" />


### Step 2: Train a Random Forest Classifier using scikit-learn to predict the binary outcome is_late based on features like Origin, Carrier, and Month.
In this step, we turn our Python script from a simple "data fetcher" into an intelligent "prediction engine."
We have the data, but raw text like "Tokyo" or "FastTrack Logistics" is meaningless to a mathematical formula. The Machine Learning model only understands numbers.

#### What we will do in this step:

i.	Translation (Encoding): We will convert categorical text (like Origin: Tokyo) into a format the machine understands using a technique called One-Hot Encoding (converting them into binary columns like is_Tokyo = 1).

ii.	The Split: We will cut your 73,000 rows into two piles:

o	Training Set (80%): The "Textbook" the model studies to learn patterns.

o	Testing Set (20%): The "Final Exam" we hide from the model to test its accuracy later.

iii.	The Algorithm: We will feed the training data into a Random Forest Classifier. This algorithm builds hundreds of small "Decision Trees" and averages their results to make highly accurate predictions about whether a shipment will be late.


•	We need scikit-learn (the AI library) to build the model. Run this command in your terminal (ensure (venv) is active)
```
pip install scikit-learn joblib
``` 
<img width="975" height="281" alt="image" src="https://github.com/user-attachments/assets/70af41aa-8b29-4c91-abe4-2f2747cd639a" />


•	Create a new file named train_model.py inside your ml_pipeline folder and paste the below script;
```
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report
import joblib
import db_connector  # This is the script you wrote in Step 1

# 1. Load Data
print("Loading data from MySQL...")
df = db_connector.get_training_data()

# 2. Preprocessing (Preparing the data for the AI)
# Select the features we want the model to learn from
features = ['carrier', 'origin', 'destination', 'ship_month', 'ship_day_of_week', 'shipping_cost']
target = 'is_late'

X = df[features]
y = df[target]

# One-Hot Encoding: Convert text (e.g., 'Tokyo') into numbers (e.g., Tokyo=1, Mumbai=0)
print("Encoding categorical features...")
X_encoded = pd.get_dummies(X, columns=['carrier', 'origin', 'destination'])

# 3. Split Data (80% for Training, 20% for Testing)
print("Splitting data...")
X_train, X_test, y_train, y_test = train_test_split(X_encoded, y, test_size=0.2, random_state=42)

# 4. Train the Model
print("Training Random Forest Classifier (this may take a moment)...")
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

# 5. Evaluate
print("Evaluating performance...")
predictions = model.predict(X_test)
accuracy = accuracy_score(y_test, predictions)

print(f"\n--- Model Results ---")
print(f"Accuracy: {accuracy:.2%}") # Shows percentage (e.g., 85.20%)
print("\nDetailed Report:")
print(classification_report(y_test, predictions))

# 6. Serialize (Save) the Model and the Column Structure
# We save the 'columns' so we know how to match the format later during live predictions
print("Saving model to disk...")
model_data = {
    'model': model,
    'model_columns': X_encoded.columns.tolist()
}
joblib.dump(model_data, 'prediction_model.pkl')
print("Success! Model saved as 'prediction_model.pkl'")
```

#### What this code does:

a.	Imports Data: Uses your db_connector to pull the 73,000 rows.

b.	Encodes: Converts text like "Nexus Air" into numbers (0s and 1s) so the math works.

c.	Splits: Hides 20% of the data to test the model later.

d.	Trains: Uses RandomForestClassifier to find the patterns causing delays.

e.	Serializes (Step 3 Preview): It saves the trained brain to a file (model.pkl) so we can use it later.


•	Now, run the script. It will connect to our database, download the data, and start learning.
```
python train_model.py
```
<img width="975" height="581" alt="image" src="https://github.com/user-attachments/assets/0b743209-23a8-407d-b449-11f67d93b5fa" />


### Step 3: Execute a "Write-Back" routine that runs the model on active shipments and updates the predicted_delay_risk column in the live MySQL database with the probability score (0.0 to 1.0).

This is the final and most critical step of the Python engineering phase. It completes the "Closed Loop" of analytics.
Currently, our trained AI model sits isolated in a Python file. It is smart, but it is useless to the business because the actual data in our database still has an empty delay_risk_score column. A logistics manager looking at the database has no idea which shipments are about to fail.

We will write a script named run_predictions.py that acts as the bridge back to reality. It performs three actions:

i.	Wake Up the Brain: It loads your saved prediction_model.pkl file.

ii.	Calculate Risk: Instead of just guessing "Late" or "On Time," it asks the model for a probability percentage (e.g., "There is an 88.5% chance this specific shipment will be late").

iii.	Enrich the Database: It connects to MySQL and physically updates every single row, filling the delay_risk_score column with these new predictions.

Our database transforms from a historical record into a forward-looking predictive engine.

•	Create a new file named run_predictions.py inside your ml_pipeline folder and paste the below script;
```
import pandas as pd
import joblib
from sqlalchemy import create_engine, text
from urllib.parse import quote_plus
import db_connector

# 1. Database Setup
DB_USER = 'nexus_user'
DB_PASSWORD = 'YOUR_PASSWORD' 
DB_HOST = 'localhost'
DB_NAME = 'nexus_db'

def run_writeback():
    print("1. Loading Model and Data...")
    model_data = joblib.load('prediction_model.pkl')
    model = model_data['model']
    model_columns = model_data['model_columns']
    
    df = db_connector.get_training_data()
    
    # 2. Preprocessing
    prediction_df = df[['tracking_number']].copy()
    
    features = ['carrier', 'origin', 'destination', 'ship_month', 'ship_day_of_week', 'shipping_cost']
    X = df[features]
    X_encoded = pd.get_dummies(X, columns=['carrier', 'origin', 'destination'])
    
    # Align columns
    X_final = X_encoded.reindex(columns=model_columns, fill_value=0)
    
    print("2. Generating Risk Scores...")
    # Get probability (0.0 to 1.0)
    raw_scores = model.predict_proba(X_final)[:, 1]
    
    # --- FIX: CONVERT TO PERCENTAGE (0 to 100) ---
    # Multiply by 100 and round to 2 decimal places
    clean_scores = (raw_scores * 100).round(2)
    
    prediction_df['delay_risk_score'] = clean_scores
    
    print("3. Writing to Database (Staging)...")
    encoded_password = quote_plus(DB_PASSWORD)
    connection_string = f"mysql+pymysql://{DB_USER}:{encoded_password}@{DB_HOST}/{DB_NAME}"
    engine = create_engine(connection_string)
    
    prediction_df.to_sql('prediction_staging', engine, if_exists='replace', index=False)
    
    print("4. Updating Main Table (Bulk Update)...")
    with engine.begin() as conn:
        update_query = text("""
            UPDATE shipments s
            JOIN prediction_staging p ON s.tracking_number = p.tracking_number
            SET s.delay_risk_score = p.delay_risk_score;
        """)
        conn.execute(update_query)
        conn.execute(text("DROP TABLE prediction_staging;"))
        
    print("Success! Risk Scores converted to Percentages (0-100).")

if __name__ == "__main__":
    try:
        run_writeback()
    except Exception as e:
        print(f"Error: {e}")
```

#### Key features of this script:

a.	Re-Indexing: It forces the new data to have the exact same columns as the training data. This prevents crashes if a specific city or carrier doesn't appear in the new batch.

b.	predict_proba: We don't just ask "Late/Not Late"; we ask for the percentage confidence (e.g., 0.85).

c.	Bulk Update: It creates a temporary table prediction_staging, uploads the scores there, and then runs one massive SQL command to update your main table instantly.

•	Run the script to update your live database.
```
python run_predictions.py
```
<img width="975" height="192" alt="image" src="https://github.com/user-attachments/assets/f152019a-fb69-4400-901d-d0d08c37cc2b" />


•	Let's check the database to see if the empty column is now full. Run this MySQL command:
```
mysql -u nexus_user -p -e "SELECT tracking_number, status, delay_risk_score FROM nexus_db.shipments LIMIT 10;"
```
 <img width="975" height="234" alt="image" src="https://github.com/user-attachments/assets/551f61b5-0097-4a18-9a64-e08a2dbefba3" />


### PHASE 4: LOOKML SEMANTIC MODELING
### Step 1: Connect Looker to the MySQL database/ Building the Complete Semantic Model.

In this step, we are bridging the gap between our raw database and the business users. We will create a single "Source of Truth" file called shipments.view.lkml.
Instead of just listing columns (Dimensions), we are immediately adding the "Business Math" (Measures) alongside them.

•	Dimensions: Define what the data is (e.g., Carrier, Origin).

•	Measures: Define calculations the business cares about (e.g., Average Predicted Risk and On-Time Delivery Rate).

By doing this in one file, we transform the raw MySQL table directly into a powerful analytics engine that answers questions like "Which carrier has the highest average risk score?"

This creates a Single Source of Truth. By defining these rules in code now, we ensure that every chart, graph, and dashboard built later uses the exact same definitions, preventing the common problem where two managers present different numbers for the same metric.

•	We will create a separate directory to keep your BI code organized. Run;
```
cd ~/projects/Nexus-Supply-Chain
mkdir lookml_project
cd lookml_project
```

•	Create the file named shipments.view.lkml and paste the below script.
```
view: shipments {
  # --- PART 1: CONNECTION ---
  # Connect this View to your MySQL Table
  sql_table_name: nexus_db.shipments ;;

  # --- PART 2: DIMENSIONS (The Columns) ---

  # The Unique ID
  dimension: tracking_number {
    primary_key: yes
    type: string
    sql: ${TABLE}.tracking_number ;;
  }

  dimension: carrier {
    type: string
    sql: ${TABLE}.carrier ;;
  }

  dimension: origin {
    type: string
    sql: ${TABLE}.origin ;;
  }

  dimension: destination {
    type: string
    sql: ${TABLE}.destination ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  # Dates (Looker automatically creates Date, Week, Month, Year)
  dimension_group: ship_date {
    type: time
    timeframes: [raw, date, week, month, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ship_date ;;
  }

  dimension: shipping_cost {
    type: number
    sql: ${TABLE}.shipping_cost ;;
    value_format_name: usd
  }

  # The AI Prediction (Raw Number stored in DB)
  dimension: delay_risk_score {
    type: number
    sql: ${TABLE}.delay_risk_score ;;
    value_format: "0.00\%"
  }

  # --- PART 3: MEASURES (The Business Logic) ---

  # 1. Total Volume (Count of all rows)
  measure: count {
    type: count
    drill_fields: [tracking_number, carrier, status]
    label: "Total Shipment Volume"
  }

  # 2. Total Freight Spend (Sum of cost)
  measure: total_shipping_cost {
    type: sum
    sql: ${shipping_cost} ;;
    value_format_name: usd
    label: "Total Freight Spend"
  }

  # 3. Late Shipment Count (Filters for 'Late' only)
  measure: count_late_shipments {
    type: count
    filters: [status: "Late"]
    label: "Late Shipment Volume"
  }

  # 4. AI Risk Metric (Average of the prediction column)
  measure: average_predicted_risk {
    type: average
    sql: ${delay_risk_score} ;;
    value_format: "0.00\%"
    label: "Avg. Predicted Risk Score"
  }

  # 5. On-Time In Full (OTIF) Rate Calculation
  measure: on_time_rate {
    type: number
    sql: 1 - (${count_late_shipments} / NULLIF(${count},0)) ;;
    value_format: "0.0\%"
    label: "On-Time Delivery Rate"
  }
}
```

### Step 2: Implement a "Prediction vs. Actual" analysis view to monitor the accuracy of the Machine Learning model over time.

Now that we have an AI model predicting risks, the business will inevitably ask: "Can we trust these predictions?"
In this step, we create a specific analysis file called prediction_analysis.view.lkml. This file defines a Derived Table, which is a powerful Looker feature that lets you run a custom SQL query before Looker touches the data.
It groups your 73,000 shipments into four "Risk Buckets" based on the AI's score:

i.	Low Risk (0-20%)

ii.	Medium Risk (21-60%)

iii.	High Risk (61-80%)

iv.	Critical Risk (>80%)

Then, for each bucket, it counts how many shipments actually arrived late.
We want to see a staircase pattern. The "Critical Risk" bucket should have a very high failure rate (e.g., 90%), while the "Low Risk" bucket should be near 0%. This proves the model works.

•	Create a new file named prediction_analysis.view.lkml and paste the below script
```
view: prediction_analysis {
  # --- 1. DERIVED TABLE (The Bucketing Logic) ---
  # This SQL query runs first to group the raw data
  derived_table: {
    sql:
      SELECT
        CASE
          WHEN delay_risk_score BETWEEN 0 AND 20 THEN '1. Low Risk (0-20%)'
          WHEN delay_risk_score BETWEEN 20.01 AND 60 THEN '2. Medium Risk (21-60%)'
          WHEN delay_risk_score BETWEEN 60.01 AND 80 THEN '3. High Risk (61-80%)'
          WHEN delay_risk_score > 80 THEN '4. Critical Risk (>80%)'
          ELSE 'Unknown'
        END AS risk_bucket,
        COUNT(*) as total_volume,
        SUM(is_late) as actual_late_count
      FROM nexus_db.shipments
      GROUP BY 1
      ;;
  }

  # --- 2. DIMENSIONS (The Buckets) ---
  dimension: risk_bucket {
    type: string
    sql: ${TABLE}.risk_bucket ;;
    description: "Grouped risk levels to validate AI accuracy"
  }

  dimension: total_volume {
    type: number
    sql: ${TABLE}.total_volume ;;
    hidden: yes # Hide raw numbers, show measures instead
  }

  dimension: actual_late_count {
    type: number
    sql: ${TABLE}.actual_late_count ;;
    hidden: yes
  }

  # --- 3. MEASURES (The Accuracy Metrics) ---

  # Count of shipments in each bucket
  measure: bucket_count {
    type: sum
    sql: ${total_volume} ;;
    label: "Total Shipments in Bucket"
  }

  # The Critical Metric: "Did the AI get it right?"
  # We expect this % to be HIGH for Critical Risk and LOW for Low Risk
  measure: actual_failure_rate {
    type: number
    sql: SUM(${actual_late_count}) / NULLIF(SUM(${total_volume}), 0) ;;
    value_format: "0.0\%"
    label: "Actual Failure Rate"
    description: "Percentage of shipments in this risk bucket that actually arrived late"
  }
}
```

### PHASE 5: VISUALIZATION & DEPLOYMENT
### Step 1: Design the "Control Tower" Dashboard to feature a "Future Risk" panel, visualizing which upcoming shipments have a >80% ML-predicted probability of delay.

We have arrived at the final frontier. We have successfully built the "Back-End" (Database, AI, Logic); now we build the "Front-End."
We will design the Executive Control Tower. Unlike a standard report that shows "Last Month's Sales," this dashboard focuses on the "Future Risk Panel". We will use Google Looker Studio to visualize our ML data. The centerpiece will be a filtered view showing only the upcoming shipments with a >80% probability of delay, allowing managers to intervene before the problem happens.
To design this dashboard, Google's servers need to talk to our Contabo VPS. Right now, our database is locked down (Localhost only). Before we can drag-and-drop charts, we must open the gates to allow remote connections.

•	By default, MySQL only listens to "localhost" (internal traffic). We need to tell it to listen to the internet. Open the main config file:
```
sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf
```

•	Find the line that says: bind-address = 127.0.0.1. Change it to: 0.0.0.0
 <img width="975" height="370" alt="image" src="https://github.com/user-attachments/assets/d1b46db7-ee70-47cb-baa0-7e7bdc6ab803" />



•	Save it and restart MySQL. RUN;
```
sudo systemctl restart mysql
```
•	For security, we should create a specific user for Looker Studio rather than opening up your root account. Log in to MySQL, run;
```
sudo mysql -u root -p
```

•	Run these commands to create a user that can connect from anywhere (%): (Replace strong_password with a secure password you will remember);
```
CREATE USER 'looker_user'@'%' IDENTIFIED BY 'strong_password';
GRANT SELECT ON nexus_db.* TO 'looker_user'@'%';
FLUSH PRIVILEGES;
EXIT;
```

•	Finally, we need to allow traffic through port 3306 (the standard MySQL port). Run;
```
sudo ufw allow 3306/tcp
```

 
Now we leave the terminal and go to the browser!
•	Open Google Looker Studio.

•	Click Create -> Data Source.
<img width="956" height="481" alt="image" src="https://github.com/user-attachments/assets/395044ca-877e-455c-b768-3f0e133c2424" />

 
•	Search for MySQL and select it.
<img width="975" height="494" alt="image" src="https://github.com/user-attachments/assets/1b4497d7-978b-4959-83b0-164da2bca110" />

 
•	Enter your connection details:

o	Hostname: Your VPS IP Address (The same one you use to SSH).

o	Database: nexus_db

o	Username: looker_user

o	Password: The password you just created in Step 3.

•	Click Authenticate.
 <img width="975" height="591" alt="image" src="https://github.com/user-attachments/assets/d7a30775-9527-4af9-b04f-ecefe917f167" />



•	Select Your Data. Click on shipments in that list. Click the blue ADD (or CONNECT) button in the bottom/top right corner. A pop-up will ask "You are about to add data to this report." Click Create Report.
 <img width="975" height="353" alt="image" src="https://github.com/user-attachments/assets/794dfbef-172c-4f8c-8a7f-403aa5f86972" />


•	Look at the top menu bar in Looker Studio. Click the button that says Add a chart.
 <img width="975" height="211" alt="image" src="https://github.com/user-attachments/assets/db8385e5-cccb-4ee4-99cc-54eaabc6721c" />
 

•	Select the Table icon (it is usually the second option in the list). Click anywhere on the white canvas to draw/place the table.
 <img width="916" height="389" alt="image" src="https://github.com/user-attachments/assets/a3f097ae-3805-4a67-80cd-58793d20e3af" />


•	Dimensions: Drag and drop these 4 fields from the list on the right into the Dimension slot:

o	tracking_number

o	carrier

o	origin

o	status
 
<img width="930" height="494" alt="image" src="https://github.com/user-attachments/assets/44289190-333f-42eb-a9db-f3d919af0d01" />


•	Metric: Drag delay_risk_score into the Metric slot.
 <img width="975" height="559" alt="image" src="https://github.com/user-attachments/assets/b6ee7892-2ba2-4983-8f7f-700f47125520" />


Right now, the table shows all shipments. We only want to see the dangerous ones.

•	Scroll down to the upper of the right sidebar.

•	Click Add a filter. Select delay_risk_score.
 <img width="869" height="567" alt="image" src="https://github.com/user-attachments/assets/6493d5ff-cac3-499d-9e32-5fd9c66ba64a" />



•	Name: Type High Risk Only.

•	Configure the Rule:

o	Select Include.

o	Select Field: delay_risk_score.

o	Select Condition: Greater than (>).

o	Value: Type 80.
<img width="644" height="273" alt="image" src="https://github.com/user-attachments/assets/d3758109-0c27-4fa7-81ea-81787eab13ae" />

 
•	Click SAVE.

### Step 2: Configure geospatial map layers to color-code routes based on their predicted risk scores (Red = High Probability of Delay).

In Step 1, we built a list of high-risk shipments. While useful, a list doesn't tell us where the trouble is coming from. In Step 2, we will build a Geospatial Bubble Map. We will take the latitude and longitude data hidden inside your Origin city names and plot them on a world map.

How it works:

•	Location: We map the bubbles to the Origin cities (e.g., Mumbai, Hamburg).

•	Size: We make the bubbles bigger based on Volume (how many shipments are leaving that city).

•	Color: We color the bubbles based on the AI Risk Score (Green = Safe, Red = High Probability of Delay).

With this, a logistics manager can look at the screen and instantly say, "Mumbai is glowing Red—we have a regional bottleneck there," without reading a single row of data.

•	Look at the top menu bar. Click Add a chart. Select Bubble Map (It looks like a world map with circles).
 <img width="584" height="244" alt="image" src="https://github.com/user-attachments/assets/f6511631-d47c-40a7-9883-cc33992e354a" />


•	Click on the white canvas (next to your table) to place the map.
 <img width="975" height="453" alt="image" src="https://github.com/user-attachments/assets/cc620d5d-1704-40d7-98c5-7e503f0a0741" />


•	Click once on the bubble map you just added so the properties panel opens on the right.

•	Drag and drop origin into the Location slot.
<img width="975" height="418" alt="image" src="https://github.com/user-attachments/assets/5ef77a1c-fb44-43a6-9b46-916853b63856" />
 

•	Size: Drag Record Count into the Size slot. (This makes cities with more shipments look bigger).
 <img width="886" height="528" alt="image" src="https://github.com/user-attachments/assets/6f7c6f70-12c6-4b42-8523-8d2b26a02d2e" />


•	Color Metric: Drag delay_risk_score into the Color metric slot.
 <img width="975" height="449" alt="image" src="https://github.com/user-attachments/assets/5bfd403b-ced3-41de-acb9-135a7714b601" />



•	Crucial Step (Average Risk):

o	Look at the delay_risk_score inside the Color metric slot.

o	You will see a tiny pencil icon (or "SUM"). Click it.

o	Change the Aggregation from SUM to AVG (Average).

o	Why? We want the Average risk of the city, not the total sum.
 <img width="809" height="566" alt="image" src="https://github.com/user-attachments/assets/96f68a33-fe0c-4cf4-8dd9-5cc564d743b6" />




•	Keep the map selected. At the top of the Right Sidebar, click the tab labeled STYLE. Scroll down to the Color section.

•	You will see a "Max Color" (or Color Ramp) option.

o	Min (Low Value): Select a Green color (Safe).

o	Max (High Value): Select a Bright Red color (High Risk).
<img width="392" height="428" alt="image" src="https://github.com/user-attachments/assets/93c2f3b3-d683-41c2-8e64-8677a78f8397" />
 

Our map should now show cities like "Mumbai" or "New York" glowing Red if they have a high average delay risk.

### Step 3: Implement Drill-Down functionality allowing users to click a "High Risk" alert and see the specific operational bottlenecks. 

Currently, we have a Map that shows where problems are, and a Table that lists what the shipments are. However, they are currently "disconnected." If a manager sees a huge red bubble over Tokyo, they still have to manually scroll through the table to find the Tokyo shipments. That is inefficient.
We will enable "Cross-Filtering" (also known as Drill-Down). This turns your static picture into an Interactive App. We will wire the components together so that clicking on a specific data point (like a Red Bubble) instantly filters the rest of the dashboard to show only relevant details.
This allows for Root Cause Analysis. A user can go from the "Big Picture" (Global Map) to the "Specific Problem" (The 5 late shipments in Tokyo) in a single click.

#### Enable Interaction on the Map

•	Select the Map: Click once on your Bubble Map.

•	Scroll Down: Look at the Right Sidebar (Setup/Data tab) and scroll to the very bottom.

•	Find "Chart Interactions": You will see a checkbox labeled Cross-filtering.

•	Turn it ON: Check that box.
 <img width="664" height="153" alt="image" src="https://github.com/user-attachments/assets/3835e033-8997-48d6-8150-f02e33185bf4" />

#### Enable Interaction on the Table

•	Select the Table: Click once on your "High Risk" Table.

•	Scroll Down: Go to the bottom of the Right Sidebar.

•	Turn it ON: Check the Cross-filtering box there too.
<img width="673" height="216" alt="image" src="https://github.com/user-attachments/assets/baa3f292-62e7-484b-b99f-f33c81dd54ac" />
 


#### Test the Drill-Down (The Final Test)

•	Go to the top right of the screen and click the blue View button (to leave "Edit" mode).
<img width="889" height="242" alt="image" src="https://github.com/user-attachments/assets/d241b138-e174-40e0-bb05-fb212a90c60e" />
 

•	Click on a Red Bubble on your map (e.g., select a specific city).

•	Watch the Table: It should automatically update to show only the shipments for that city.
 


### Conclusion
The completion of the Global Supply Chain Control Tower marks a successful transformation of "Nexus Logistics" from a reactive operation into a data-driven, predictive organization. By converging Cloud Engineering, Machine Learning, and Enterprise Business Intelligence, we have solved the critical latency problem that plagues modern supply chains.
Over the course of five phases, we achieved the following technical and business milestones:
i.	Scalable Infrastructure: We deployed a normalized MySQL Data Warehouse capable of ingesting and querying 73,000+ transactional records with sub-second latency, solving the "Scale vs. Speed" bottleneck.
ii.	Predictive Intelligence: We moved beyond simple historical reporting by engineering a Random Forest Classifier that detects delay patterns with ~80% accuracy. By implementing a production-grade "Write-Back" loop, we enriched the live database with future intelligence, allowing the system to flag risks before they manifest.
iii.	Semantic Truth: Through LookML modeling, we standardized critical KPIs like "Average Predicted Risk," ensuring a unified view of vendor performance across the organization.
iv.	Actionable Visualization: The final deployment of the Looker Studio Control Tower provides Operations Managers with a geospatial "Early Warning System." The implementation of cross-filtering allows users to drill down from a global view of high-risk regions (Red Bubbles) to specific shipment bottlenecks in seconds.
This project demonstrates that valuable insights are not just about collecting data, but about operationalizing predictions. "Nexus Logistics" now possesses the capability to intervene on high-risk shipments before they leave the dock, protecting revenue and preserving customer trust.




