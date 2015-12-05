import numpy as np
import nltk
import csv
import pickle
import random
import re
from nltk import word_tokenize
from nltk.corpus import stopwords
from sklearn.pipeline import Pipeline
from sklearn.svm import LinearSVC
from sklearn.naive_bayes import MultinomialNB
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.multiclass import OneVsRestClassifier

stop_words = set(stopwords.words('english'))
stop_words.update( set(line.strip() for line in open('customstopwords.txt')) )

test_data_array = list( csv.reader( open("LMUTwitterFacebookCorpus.csv") ) )
headers = test_data_array.pop(0)
label_headers = headers[1:]

random.shuffle(test_data_array)
train_length = len(test_data_array) * .9

posts = []
binary_labels = []
for row in test_data_array:
   posts.append( (row.pop(0)).decode("string_escape") )
   labels = []
   for label in row:
      labels.append( int(label) )
   binary_labels.append( labels )

def process(string):
   words = []
   split_string = string.split()
   for string in split_string:
      if bool(re.search(r'\d', string)) or "http" in string or "&amp" in string or "www" in string:
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

posts_train = posts[:train_length]
binary_labels_train = binary_labels[:train_length]
posts_test = posts[train_length:]
binary_labels_test = binary_labels[train_length:]

def makePipeline(classifier):
   return Pipeline([
    ('vectorizer', TfidfVectorizer(max_features=2000)),
    ('clf', OneVsRestClassifier(classifier))])

SVCclassifier = makePipeline(LinearSVC())
SVCclassifier.fit(posts_train, binary_labels_train)
score = SVCclassifier.score(posts_test, binary_labels_test)

print "SVCclassifier", score
print SVCclassifier.named_steps["vectorizer"].get_feature_names()

# save_classifier = open("post-classifier.pickle", "wb")
# pickle.dump(SVCclassifier, save_classifier)
# save_classifier.close()