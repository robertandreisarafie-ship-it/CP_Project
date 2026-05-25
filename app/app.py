import os
import hvac

app_secret_key = None

def get_secret():
    global app_secret_key
    if app_secret_key:
        return app_secret_key
    client = hvac.Client(
        url=os.environ['VAULT_ADDR'],
        token=os.environ['VAULT_TOKEN']
    )
    secret = client.secrets.kv.read_secret_version(path='myapp')
    app_secret_key = secret['data']['data']['api_key']
    return app_secret_key

from flask import Flask, jsonify
app = Flask(__name__)

@app.route('/')
def index():
    key = get_secret()
    return jsonify({
        "status": "ok",
        "message": "Secret retrieved from Vault successfully",
        "api_key_preview": f"{key[:4]}****"  # never expose the full key
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)