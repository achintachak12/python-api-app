import flask
from flask import request, jsonify
app = flask.Flask(__name__)
app.config["DEBUG"] = True

version = "v1"

@app.route('/', methods=['GET'])
def home():
    return '''<h1>Python based API application</h1>'''

@app.route('/version', methods=['GET'])
def get_vers():
    return jsonify("You are using API(Version: {})".format(version))


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=8080)