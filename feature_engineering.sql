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