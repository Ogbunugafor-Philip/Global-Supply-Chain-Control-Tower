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