from flask import Flask, request, jsonify, render_template
import mysql.connector
from datetime import datetime

app = Flask(__name__)

# Database configuration
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'mysql12345',
    'database': 'EduSchema'
}

# Connect to the database
def get_db_connection():
    return mysql.connector.connect(**db_config)

# Archive and delete student
@app.route('/delete_student/<int:student_id>', methods=['DELETE'])
def delete_student(student_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("SELECT * FROM Students WHERE student_id = %s", (student_id,))
        student = cursor.fetchone()
        if student:
            cursor.execute(
                "INSERT INTO Deleted_Items (table_name, deleted_id, details) VALUES ('Students', %s, %s)",
                (student_id, f"first_name: {student[1]}, last_name: {student[2]}, email: {student[3]}")
            )
            cursor.execute("DELETE FROM Students WHERE student_id = %s", (student_id,))
            conn.commit()
            return jsonify({'message': 'Student deleted and archived successfully.'}), 200
        else:
            return jsonify({'message': 'Student not found.'}), 404
    except mysql.connector.Error as err:
        conn.rollback()
        return jsonify({'error': str(err)}), 500
    finally:
        cursor.close()
        conn.close()

# Render the main page
@app.route('/')
def index():
    return render_template('frontend.html')

if __name__ == '__main__':
    app.run(debug=True)
