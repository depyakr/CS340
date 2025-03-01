from flask import Flask, request, jsonify, render_template
from flask_cors import CORS
import pymysql

app = Flask(__name__)
CORS(app)

# Database connection
db = pymysql.connect(
    host='localhost',
    user='root',
    password='f]W9M|apyO54',
    database='event_management'
)

@app.route('/')
def index():
    return render_template('index.html')

@app.route("/manage-event-attendees")
def manage_event_attendees():
    return render_template("event_has_attendees.html")

# CREATE: Add an attendee to an event
@app.route('/api/event_has_attendees', methods=['POST'])
def add_event_attendee():
    data = request.json
    print(data)  # Debugging line
    if not data.get('event_id') or not data.get('attendee_id'):
        return jsonify({'error': 'Missing event_id or attendee_id'}), 400

    try:
        cursor = db.cursor()
        check_query = '''
            SELECT 1 FROM Event_has_attendees
            WHERE event_id = %s AND attendee_id = %s
        '''
        cursor.execute(check_query, (data['event_id'], data['attendee_id']))
        existing_entry = cursor.fetchone()

        if existing_entry:
            return jsonify({'error': 'Attendee is already added to the event'}), 400

        insert_query = 'INSERT INTO Event_has_attendees (event_id, attendee_id) VALUES (%s, %s)'
        cursor.execute(insert_query, (data['event_id'], data['attendee_id']))
        db.commit()
        cursor.close()

        return jsonify({'message': 'Attendee added to event successfully'}), 201
    except pymysql.MySQLError as e:
        db.rollback()
        print("SQL Error:", str(e))
        return jsonify({'error': str(e)}), 500

# READ: View all event-attendee pairs
@app.route('/api/event_has_attendees', methods=['GET'])
def get_event_attendees():
    try:
        cursor = db.cursor(pymysql.cursors.DictCursor)
        query = '''
            SELECT eha.event_id, e.event_name, e.event_date, a.attendee_id, a.first_name, a.last_name
            FROM Event_has_attendees AS eha
            JOIN Events AS e ON eha.event_id = e.event_id
            JOIN Attendees AS a ON eha.attendee_id = a.attendee_id
        '''
        cursor.execute(query)
        results = cursor.fetchall()
        cursor.close()
        return jsonify(results), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# UPDATE: Change the attendee for a specific event
@app.route('/api/event_has_attendees', methods=['PUT'])
def update_event_attendee():
    data = request.json
    if not all(k in data for k in ('event_id', 'attendee_id', 'new_event_id', 'new_attendee_id')):
        return jsonify({'error': 'Missing required fields'}), 400

    try:
        cursor = db.cursor()
        query = '''
            UPDATE Event_has_attendees
            SET event_id = %s, attendee_id = %s
            WHERE event_id = %s AND attendee_id = %s
        '''
        cursor.execute(query, (data['new_event_id'], data['new_attendee_id'], data['event_id'], data['attendee_id']))
        if cursor.rowcount == 0:
            return jsonify({'error': 'No matching record found'}), 404

        db.commit()
        cursor.close()
        return jsonify({'message': 'Event attendee updated successfully'}), 200
    except Exception as e:
        db.rollback()
        return jsonify({'error': str(e)}), 500

# DELETE: Remove an attendee from an event
@app.route('/api/event_has_attendees', methods=['DELETE'])
def delete_event_attendee():
    data = request.json
    if not data.get('event_id') or not data.get('attendee_id'):
        return jsonify({'error': 'Missing event_id or attendee_id'}), 400

    try:
        cursor = db.cursor()
        query = 'DELETE FROM Event_has_attendees WHERE event_id = %s AND attendee_id = %s'
        cursor.execute(query, (data['event_id'], data['attendee_id']))
        if cursor.rowcount == 0:
            return jsonify({'error': 'No matching record found'}), 404

        db.commit()
        cursor.close()
        return jsonify({'message': 'Attendee removed from event successfully'}), 200
    except Exception as e:
        db.rollback()
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
