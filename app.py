from crypt import methods
from flask import Flask, jsonfy, request
import time

app = Flask(__name__)
@app.route("/bot", method = ["POST"])

#response
def response(): 