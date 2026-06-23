import os
import shlex
from flask import Flask, request  # $ Source

app = Flask(__name__)


@app.route("/run")
def run_command_safe():
    """shlex.quote properly escapes shell metacharacters - safe from injection."""
    filename = request.args.get("filename", "")
    safe_filename = shlex.quote(filename)
    os.system("cat " + safe_filename)  # Safe - shlex.quote sanitizes


@app.route("/run_unsafe")
def run_command_unsafe():
    """Direct concatenation without quoting is vulnerable."""
    filename = request.args.get("filename", "")
    os.system("cat " + filename)  # $ Alert


@app.route("/run_pipes")
def run_command_pipes_quote():
    """pipes.quote is the Python 2 equivalent of shlex.quote."""
    import pipes
    filename = request.args.get("filename", "")
    safe_filename = pipes.quote(filename)
    os.system("cat " + safe_filename)  # Safe - pipes.quote sanitizes
