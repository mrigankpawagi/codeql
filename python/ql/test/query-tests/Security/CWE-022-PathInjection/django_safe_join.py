from django.utils._os import safe_join
from flask import Flask, request  # $ Source

app = Flask(__name__)

MEDIA_ROOT = "/var/www/media"


@app.route("/file")
def serve_file():
    filename = request.args.get("filename", "")  # user input
    # safe_join validates the path stays within MEDIA_ROOT
    safe_path = safe_join(MEDIA_ROOT, filename)
    open(safe_path)  # Safe - no alert expected


@app.route("/file_unsafe")
def serve_file_unsafe():
    filename = request.args.get("filename", "")  # user input
    unsafe_path = MEDIA_ROOT + "/" + filename
    open(unsafe_path)  # $ Alert
