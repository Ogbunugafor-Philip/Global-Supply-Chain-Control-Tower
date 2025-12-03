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