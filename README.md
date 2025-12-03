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
