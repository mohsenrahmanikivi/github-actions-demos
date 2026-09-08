from flask import Flask, jsonify
import logging
import os
import psycopg2
import time

app = Flask(__name__)

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s"
)


@app.route("/")
def home():

    logging.info("Home endpoint called")

    return jsonify({
        "message": "SRE Practice API",
        "status": "running"
    })


@app.route("/health")
def health():

    return jsonify({
        "status": "healthy"
    }), 200


@app.route("/db-check")
def database_check():

    try:

        connection = psycopg2.connect(
            host=os.getenv("DB_HOST"),
            database=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASSWORD"),
            port=os.getenv("DB_PORT")
        )

        connection.close()

        return jsonify({
            "database": "connected"
        })

    except Exception as error:

        logging.error(
            f"Database connection failed: {error}"
        )

        return jsonify({
            "database": "failed",
            "error": str(error)
        }), 500


@app.route("/slow")
def slow():

    time.sleep(5)

    return jsonify({
        "message": "Slow response"
    })


@app.route("/error")
def error():

    logging.error("Intentional application error")

    return jsonify({
        "error": "Intentional error"
    }), 500


if __name__ == "__main__":

    app.run(
        host="0.0.0.0",
        port=5050
    )