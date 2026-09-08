from flask import Flask, jsonify
import logging
import time
import random

app = Flask(__name__)

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s"
)


@app.route("/")
def home():
    logging.info("Home endpoint called")
    return jsonify({
        "message": "SRE Interview Practice API",
        "status": "running"
    })


@app.route("/health")
def health():
    return jsonify({
        "status": "healthy"
    }), 200


@app.route("/slow")
def slow():
    time.sleep(5)

    return jsonify({
        "message": "Slow response completed"
    })


@app.route("/error")
def error():
    logging.error("Intentional error generated")

    return jsonify({
        "error": "Something went wrong"
    }), 500


@app.route("/random")
def random_response():

    if random.randint(1, 5) == 1:
        logging.error("Random failure occurred")

        return jsonify({
            "error": "Random failure"
        }), 500

    return jsonify({
        "status": "success"
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5050)