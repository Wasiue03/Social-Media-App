from transformers import pipeline, Conversation

# Load conversational model
chatbot = pipeline("conversational", model="microsoft/DialoGPT-medium")

# User input to test
user_input = "Hello, how are you?"

# Create a Conversation object
conversation = Conversation(user_input)

# Generate response
response = chatbot(conversation)

# Check if response is empty
if response.generated_responses:
    reply = response.generated_responses[-1]
    print("Bot Response:", reply)
else:
    print("No response generated.")
