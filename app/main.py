from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def home():
    db_password = os.environ.get("DB_PASSWORD", "Not set")
    return f"Hello from Flask! DB password is: {db_password}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
