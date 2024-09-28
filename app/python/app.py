# Simple web application using Flask framework
import socket
import os
from flask import Flask, jsonify

hostname = socket.gethostname()
port = os.environ.get('APP_PORT', 8080)

app = Flask(__name__)

@app.route("/")
def hello_world():
    data = [{'hostname': f'{hostname}', 'Hello': 'World', "from": "kerenp2014-ce6", "semver": "v1.0.2"}]
    return jsonify(data=data, status=200, mimetype='application/json')

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=port)
