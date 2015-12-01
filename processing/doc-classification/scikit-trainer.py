import re
import numpy as np
import nltk
import csv
import pickle
import random
from nltk import word_tokenize
from nltk.corpus import stopwords
from sklearn.pipeline import Pipeline
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.svm import LinearSVC
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.multiclass import OneVsRestClassifier

stop_words = set(stopwords.words('english'))
stop_words.update( set(line.strip() for line in open('customstopwords.txt')) )

test_data_array = list( csv.reader( open("testdata.csv") ) )
headers = test_data_array.pop(0)
label_headers = headers[1:]

posts = []
binary_labels = []
for row in test_data_array:
   posts.append( (row.pop(0)).decode("string_escape") )
   labels = []
   for label in row:
      labels.append( int(label) )
   binary_labels.append( labels )

posts = np.array(posts)
binary_labels = np.array(binary_labels)

def process(string) :
   words = []
   split_string = string.split(' ')
   for string in split_string:
      if string.startswith("http") or string.startswith("&amp"):
         continue
      string = nltk.word_tokenize(string)
      string = [s.lower() for s in string]
      words.extend(string)
   for word in words:
      if word in stop_words:
         words = filter(lambda a: a!= word, words)
   return ' '.join(words)

posts = [process(post) for post in posts]

for post in posts:
   print post 
print binary_labels