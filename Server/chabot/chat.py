from flask import Flask, request, jsonify
from transformers import pipeline, Conversation
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
# Load conversational model
chatbot = pipeline("conversational", model="microsoft/DialoGPT-medium")

@app.route('/chat', methods=['POST'])
def chat():
    try:
        # Get the message from the request
        data = request.get_json()
        user_input = data.get('message')

        # Check if the message is empty
        if not user_input:
            return jsonify({"error": "Message is required"}), 400

        # Create a Conversation object with user input
        conversation = Conversation(user_input)

        # Generate response from the model
        response = chatbot(conversation)

        # Extract the reply from the generated responses
        reply = response.generated_responses[-1]

        return jsonify({"reply": reply}), 200

    except Exception as e:
        # Handle any errors that occur during processing
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    # Run the Flask app
    app.run(debug=True, host='0.0.0.0', port=5000)
