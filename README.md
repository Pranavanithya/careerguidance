🎯 AI-Based Career Guidance & Recommendation System
An AI-driven career guidance system that predicts suitable career domains for students based on their academic performance, skills, and certifications, and recommends relevant internships and certifications to enhance employability.

📌 Project Objective
To provide data-driven, personalized career guidance for students by using machine learning instead of generic career advice.

🧠 Machine Learning Model
Algorithm Used: Random Forest Classifier
Task: Multi-class career domain classification
Evaluation Metrics: Accuracy, Precision, Recall, F1-Score

🛠️ Data Preprocessing Techniques
Data cleaning using Pandas
Label Encoding for target variable
One-Hot Encoding for categorical features
RandomOverSampler to handle class imbalance
Stratified Train-Test Split for fair evaluation

🔄 System Workflow
1. Student inputs academic and skill details in the mobile app.
2. Data is sent to the Flask API hosted on Render.
3. The Random Forest model predicts the suitable career domain.
4. Based on prediction, the system recommends internships and certifications.
5. Results are displayed in the Flutter mobile application.

🚀 Model Deployment
Trained model saved using joblib
Hosted as a REST API on Render
Integrated with Flutter app for real-time predictions

📱 Features
Career domain prediction
Internship recommendations
Certification suggestions
Mentor–student interaction
Real-time mobile access

📊 Libraries Used
pandas
numpy
scikit-learn
joblib
flask

👨‍💻 Author
Pranavanithya T
Eric Jeevan A
