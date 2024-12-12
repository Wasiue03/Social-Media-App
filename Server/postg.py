import os
import base64
from flask import Flask, request, jsonify
import psycopg2
from werkzeug.utils import secure_filename

app = Flask(__name__)

# Database connection settings
db_connection = psycopg2.connect(
    host="localhost",
    database="blogdb",
    user="postgres",
    password="12345678"
)
db_cursor = db_connection.cursor()

# Directory to store uploaded images
UPLOAD_FOLDER = 'uploads/'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
@app.route('/create_blog', methods=['POST'])
def create_blog():
    data = request.form  # Use form for file uploads
    title = data.get('title')
    content = data.get('content')
    image_file = request.files.get('image')  # Get the uploaded image file

    if not title or not content:
        return jsonify({"error": "Title and content are required"}), 400

    if image_file:
        print(f"Image received: {image_file.filename}")
    else:
        print("No image received")

    try:
        image_url = None
        if image_file:
            # Save image to the server and get the file path
            filename = secure_filename(image_file.filename)
            file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            image_file.save(file_path)
            image_url = file_path  # You can store relative or full path depending on your needs

        # Create the blog table if it doesn't exist
        db_cursor.execute("""
            CREATE TABLE IF NOT EXISTS blogs (
                id SERIAL PRIMARY KEY,
                title VARCHAR(255),
                content TEXT,
                image_url VARCHAR(255),
                timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
        """)

        # Insert the new blog post into the database
        db_cursor.execute(
            "INSERT INTO blogs (title, content, image_url) VALUES (%s, %s, %s)",
            (title, content, image_url)
        )
        db_connection.commit()

        return jsonify({"message": "Blog created successfully"}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/get_blogs', methods=['GET'])
def get_blogs():
    try:
        db_cursor.execute("SELECT * FROM blogs ORDER BY timestamp DESC;")
        blogs = db_cursor.fetchall()

        # Convert the list of tuples into a list of dictionaries
        blogs_list = []
        for blog in blogs:
            blog_dict = {
                "id": blog[0],
                "title": blog[1],
                "content": blog[2],
                "image_url": blog[3],
                "timestamp": blog[4]
            }

            # Convert image URL to base64 if there's an image URL
            if blog_dict['image_url']:
                try:
                    with open(blog_dict['image_url'], "rb") as img_file:
                        encoded_image = base64.b64encode(img_file.read()).decode('utf-8')
                    blog_dict['image_url'] = encoded_image
                except Exception as e:
                    blog_dict['image_url'] = None  # Handle error if image is not found

            blogs_list.append(blog_dict)

        return jsonify(blogs_list), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000, use_reloader=False)
