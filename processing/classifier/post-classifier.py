import numpy as np
import nltk
import pickle
import re
import json
import os
from nltk import word_tokenize
from nltk.corpus import stopwords
from sklearn.pipeline import Pipeline
from sklearn.svm import LinearSVC
from sklearn.naive_bayes import MultinomialNB
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.multiclass import OneVsRestClassifier
from flask import Flask, request, Response
from flask import jsonify
from functools import wraps

app = Flask(__name__)

VALID_USERNAME = os.environ["USERNAME"]
VALID_PASSWORD = os.environ["PASSWORD"]

f = open('post-classifier.pickle', 'rb')
classifier = pickle.load(f)
f.close()

labels = ["food","sports","entertainment","cultural","deadline","spirituality",
         "community service","academic","career development"]

def check_auth(username, password):
    return username == VALID_USERNAME and password == VALID_PASSWORD

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

def process(string):
   words = []
   split_string = string.split()
   for string in split_string:
      if bool(re.search(r'(\d|http|\&amp|www)', string)):
            continue
      string = string.decode("unicode_escape")
      string = nltk.word_tokenize(string)
      string = [s.lower() for s in string]
      words.extend(string)
   return ' '.join(words)

@app.route("/tags", methods=['POST'])
@requires_auth
def decipherTags():
    data = json.loads(request.data)
    print data
    post = data['post']
    post = process(post)
    tags = classifier.predict([post]).flatten()
    print tags
    tags = [label for (tag,label) in zip(tags, labels) if tag == 1]
    return jsonify(tags = tags)

if __name__ == "__main__":
    app.debug = True
    app.run()