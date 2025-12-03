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