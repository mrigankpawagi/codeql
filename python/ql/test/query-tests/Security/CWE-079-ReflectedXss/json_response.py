import json
from flask import Flask, request, make_response

app = Flask(__name__)


@app.route("/api/data")
def json_api_response():
    """json.dumps output is safe - JSON-encoded data is not rendered as HTML."""
    user_input = request.args.get("data", "")
    result = json.dumps({"input": user_input})
    return make_response(result, 200, {"Content-Type": "application/json"})  # Safe


@app.route("/unsafe")
def unsafe_html_response():
    """Without json.dumps, user input in HTML response is unsafe."""
    user_input = request.args.get("data", "")
    return make_response("<html>" + user_input + "</html>")  # $ Alert
