import pytest
import json
from unittest.mock import patch, MagicMock
from app import app, get_secret, get_db_connection

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_index_route(client):
    """Test the main index route"""
    response = client.get('/')
    assert response.status_code == 200
    assert b'DevOps Assessment Application' in response.data

@patch('app.get_db_connection')
def test_health_check_healthy(mock_db_conn, client):
    """Test health check when database is healthy"""
    mock_conn = MagicMock()
    mock_db_conn.return_value = mock_conn
    
    response = client.get('/health')
    assert response.status_code == 200
    
    data = json.loads(response.data)
    assert data['status'] == 'healthy'
    assert data['database'] == 'connected'

@patch('app.get_db_connection')
def test_health_check_unhealthy(mock_db_conn, client):
    """Test health check when database is unhealthy"""
    mock_db_conn.return_value = None
    
    response = client.get('/health')
    assert response.status_code == 503
    
    data = json.loads(response.data)
    assert data['status'] == 'unhealthy'
    assert data['database'] == 'disconnected'

@patch('app.boto3.session.Session')
def test_get_secret_success(mock_session):
    """Test successful secret retrieval"""
    mock_client = MagicMock()
    mock_session.return_value.client.return_value = mock_client
    mock_client.get_secret_value.return_value = {
        'SecretString': json.dumps({'username': 'admin', 'password': 'secret'})
    }
    
    with patch.dict('os.environ', {'DB_SECRET_NAME': 'test-secret'}):
        secret = get_secret()
        assert secret['username'] == 'admin'
        assert secret['password'] == 'secret'

@patch('app.boto3.session.Session')
def test_get_secret_failure(mock_session):
    """Test secret retrieval failure"""
    mock_client = MagicMock()
    mock_session.return_value.client.return_value = mock_client
    mock_client.get_secret_value.side_effect = Exception("Secret not found")
    
    with patch.dict('os.environ', {'DB_SECRET_NAME': 'test-secret'}):
        secret = get_secret()
        assert secret is None
