import numpy as np
import nltk
import csv
import pickle
import random
from nltk import word_tokenize
from nltk.corpus import stopwords
from sklearn.pipeline import Pipeline
from sklearn.svm import LinearSVC
from sklearn.naive_bayes import MultinomialNB
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.multiclass import OneVsRestClassifier

stop_words = set(stopwords.words('english'))
stop_words.update( set(line.strip() for line in open('customstopwords.txt')) )

test_data_array = list( csv.reader( open("testdata.csv") ) )
headers = test_data_array.pop(0)
label_headers = headers[1:]

random.shuffle(test_data_array)
posts = []
binary_labels = []

for row in test_data_array:
   posts.append( (row.pop(0)).decode("string_escape") )
   labels = []
   for label in row:
      labels.append( int(label) )
   binary_labels.append( labels )

def process(string) :
   words = []
   split_string = string.split(' ')
   for string in split_string:
      if string.startswith(("http","&amp")):
         continue
      string = string.decode("unicode_escape")
      string = nltk.word_tokenize(string)
      string = [s.lower() for s in string]
      words.extend(string)
   for word in words:
      if word in stop_words:
         words = filter(lambda a: a!= word, words)
   return ' '.join(words)

posts = [process(post) for post in posts]

posts = np.array(posts)
binary_labels = np.array(binary_labels)

NBclassifier = Pipeline([
    ('vectorizer', TfidfVectorizer()),
    ('clf', OneVsRestClassifier(MultinomialNB()))])
NBclassifier.fit(posts[:10], binary_labels[:10])
predicted = NBclassifier.predict(posts[10:])
score = NBclassifier.score(posts[10:], binary_labels[10:])

for post in posts[10:]:
   print post 
print predicted
print score