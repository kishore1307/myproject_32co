import os
import json
import boto3
import psycopg2
from flask import Flask, render_template, jsonify
from botocore.exceptions import ClientError

app = Flask(__name__)

def get_secret():
    """Retrieve database credentials from AWS Secrets Manager"""
    secret_name = os.environ.get('DB_SECRET_NAME')
    region_name = os.environ.get('AWS_DEFAULT_REGION', 'us-east-1')
    
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )
    
    try:
        get_secret_value_response = client.get_secret_value(SecretId=secret_name)
        secret = json.loads(get_secret_value_response['SecretString'])
        return secret
    except ClientError as e:
        print(f"Error retrieving secret: {e}")
        return None

def get_db_connection():
    """Get database connection"""
    secret = get_secret()
    if not secret:
        return None
    
    db_endpoint = os.environ.get('DB_ENDPOINT')
    
    try:
        connection = psycopg2.connect(
            host=db_endpoint.split(':')[0],
            database='appdb',
            user=secret['username'],
            password=secret['password']
        )
        return connection
    except Exception as e:
        print(f"Error connecting to database: {e}")
        return None

@app.route('/')
def index():
    """Main application route"""
    return render_template('index.html')

@app.route('/health')
def health_check():
    """Health check endpoint"""
    try:
        conn = get_db_connection()
        if conn:
            conn.close()
            return jsonify({'status': 'healthy', 'database': 'connected'}), 200
        else:
            return jsonify({'status': 'unhealthy', 'database': 'disconnected'}), 503
    except Exception as e:
        return jsonify({'status': 'unhealthy', 'error': str(e)}), 503

@app.route('/api/data')
def get_data():
    """API endpoint to fetch data"""
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cur = conn.cursor()
        cur.execute("SELECT NOW() as current_time;")
        result = cur.fetchone()
        cur.close()
        conn.close()
        
        return jsonify({
            'message': 'Data retrieved successfully',
            'timestamp': result[0].isoformat() if result else None
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
