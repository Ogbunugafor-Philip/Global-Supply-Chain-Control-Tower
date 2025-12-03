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