import pandas as pd
from sqlalchemy import create_engine
import pymysql
from urllib.parse import quote_plus  # <--- NEW IMPORT

# 1. Database Connection Details
DB_USER = 'nexus_user'
DB_PASSWORD = 'Osita@1989'  # Your password with the special character
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