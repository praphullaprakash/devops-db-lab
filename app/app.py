from flask import Flask, jsonify
import os
import socket

app = Flask(__name__)

@app.route("/")
def home():
    return f"Hello from DevOps DB Lab! Host={socket.gethostname()}\n"

@app.route("/health")
def health():
    return jsonify({"status": "UP"})

@app.route("/env")
def env():
    return jsonify(dict(os.environ))

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

