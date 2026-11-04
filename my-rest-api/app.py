from flask import Flask, jsonify, request

app = Flask(__name__)


@app.route("/", methods=["GET"])
def home():
    return jsonify({
        "application": "my-rest-api",
        "message": "REST API is running",
        "endpoints": ["/", "/hello", "/health"]
    }), 200


@app.route("/hello", methods=["GET"])
def hello():
    name = request.args.get("name", "World")

    return jsonify({
        "message": f"Hello, {name}!"
    }), 200


@app.route("/health", methods=["GET"])
def health():
    return jsonify({
        "status": "healthy"
    }), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
