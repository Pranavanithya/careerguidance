from flask import Flask, request, jsonify
import joblib
import pandas as pd
from flask_cors import CORS
import os

app = Flask(__name__)
CORS(app)

# Load model and label encoder
model = joblib.load('career_model_rf.joblib')
label_encoder = joblib.load('career_label_encoder.joblib')

@app.route('/')
def home():
    return "Career Prediction API is running!"

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.json
        input_df = pd.DataFrame([data])
        prediction = model.predict(input_df)[0]
        predicted_label = label_encoder.inverse_transform([prediction])[0]
        return jsonify({'predicted_career': predicted_label})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 10000))  # Important for Render
    app.run(host='0.0.0.0', port=port, debug=True)
