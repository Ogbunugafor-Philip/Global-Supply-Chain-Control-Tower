import pandas as pd
import joblib
from sqlalchemy import create_engine, text
from urllib.parse import quote_plus
import db_connector

# 1. Database Setup
DB_USER = 'nexus_user'
DB_PASSWORD = 'Osita@1989' 
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