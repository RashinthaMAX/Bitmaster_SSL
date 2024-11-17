from flask import Flask, request, jsonify
from tensorflow.keras.models import load_model
from PIL import Image
import numpy as np
import io

app = Flask(__name__)

# Load your trained model
model = load_model("sinhala_sign_language_capturing_model.keras")  # Replace with your model path

# Define labels (or load from labels file if needed)
labels = ["label1", "label2", "label3"]  # Update with actual labels

def preprocess_image(image):
    # Resize and normalize the image to match model requirements
    image = image.resize((224, 224))  # Adjust size based on model input size
    image = np.array(image) / 255.0  # Normalize if required by the model
    image = np.expand_dims(image, axis=0)
    return image

@app.route("/predict", methods=["POST"])
def predict():
    if "file" not in request.files:
        return jsonify({"error": "No file provided"}), 400

    file = request.files["file"]
    image = Image.open(io.BytesIO(file.read()))
    processed_image = preprocess_image(image)

    # Get model prediction
    predictions = model.predict(processed_image)
    label_index = np.argmax(predictions[0])
    confidence = float(predictions[0][label_index])

    return jsonify({
        "predicted_class": labels[label_index],
        "confidence_score": confidence
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
