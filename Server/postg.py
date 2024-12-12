from flask import Flask, request, jsonify
import psycopg2
from psycopg2.extras import RealDictCursor

app = Flask(__name__)

# Database connection settings
db_connection = psycopg2.connect(
    host="localhost",  # Change to your PostgreSQL host
    database="blogdb",  # Your database name
    user="postgres",  # Your PostgreSQL user
    password="12345678"  # Your PostgreSQL password
)
db_cursor = db_connection.cursor(cursor_factory=RealDictCursor)


@app.route('/get_blogs', methods=['GET'])
def get_blogs():
    try:
        db_cursor.execute("SELECT * FROM blogs ORDER BY timestamp DESC;")
        blogs = db_cursor.fetchall()
        return jsonify(blogs), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/create_blog', methods=['POST'])
def create_blog():
    data = request.get_json()
    title = data.get('title')
    content = data.get('content')

    if not title or not content:
        return jsonify({"error": "Title and content are required"}), 400

    try:
        # Create the blog table if it doesn't exist
        db_cursor.execute("""
            CREATE TABLE IF NOT EXISTS blogs (
                id SERIAL PRIMARY KEY,
                title VARCHAR(255),
                content TEXT,
                timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
        """)

        # Insert the new blog post into the database
        db_cursor.execute(
            "INSERT INTO blogs (title, content) VALUES (%s, %s)",
            (title, content)
        )
        db_connection.commit()

        return jsonify({"message": "Blog created successfully"}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
