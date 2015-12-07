import pickle
import json
from flask import Flask, request, Response
from flask import jsonify
from functools import wraps

app = Flask(__name__)

#f = open('my_classifier.pickle', 'rb')
#classifier = pickle.load(f)
#f.close()

def check_auth(username, password):
    return username == 'cameron' and password == 'billingham'

def authenticate():
    return Response(
    'Could not verify your access level for that URL.\n'
    'You have to login with proper credentials', 401,
    {'WWW-Authenticate': 'Basic realm="Login Required"'})

def requires_auth(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        auth = request.authorization
        if not auth or not check_auth(auth.username, auth.password):
            return authenticate()
        return f(*args, **kwargs)
    return decorated

@app.route("/tags", methods=['POST'])
@requires_auth
def decipherTags():
    data = json.loads(request.data)
    post = data['post']
    tags = post
    tags.append(x)
    return jsonify(tags = tags)

if __name__ == "__main__":
    app.debug = True
    app.run()