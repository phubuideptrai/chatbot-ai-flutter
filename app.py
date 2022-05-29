from crypt import methods
from flask import Flask, jsonfy, request
import time

app = Flask(__name__)
@app.route("/bot", method = ["POST"])

#response
def response(): 
    querry = dict(request.form)["querry"]
    result = querry + " " + time.ctime()
    return jsonfy({"respone": result})

if __name__ == '__main__':
    app.run(host="0.0.0.0",)