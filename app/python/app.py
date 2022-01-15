import flask
from flask import request, jsonify
app = flask.Flask(__name__)
app.config["DEBUG"] = True

version = "v1"

@app.route('/', methods=['GET'])
def home():
    return '''<h1>Python based API application</h1>
                <p>Click here to get more information on the API</p>'''

@app.route('/version', methods=['GET'])
def get_vers():
    return "You are using API(Version: {})".format(version)




@app.route('/api/v1/books', methods=['GET'])
def api_id():
    results = []

    return jsonify(results)

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)