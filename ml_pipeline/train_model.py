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