import nltk
import csv
import pickle
import random
from nltk import word_tokenize
from nltk.corpus import stopwords

stop_words = set(stopwords.words('english'))
stop_words.update( set(line.strip() for line in open('customstopwords.txt')) )

test_data_array = list( csv.reader( open("testdata.csv") ) )
headers = test_data_array.pop(0)
label_headers = headers[1:]

test_data = []
for row in test_data_array:
   post = row.pop(0).decode("string_escape")
   processed_bool_row = [post]
   for label in row:
      processed_bool_row.append( bool(int(label)) )
   test_data.append( dict(zip(headers, processed_bool_row)))

def processString(string) :
   words = nltk.word_tokenize(string)
   words = [word.lower() for word in words]
   for word in words:
      if word in stop_words:
         words = filter(lambda a: a!= word, words)
   return words

all_words = []
classified_set = []
for classified_post in test_data:

   words = processString( classified_post["post"] )
   all_words.extend(words)
   print (words)

   for label in label_headers:
      if classified_post[label]:
         classified_set.append( (words, label) )

all_words = nltk.FreqDist(all_words)
word_features = all_words.keys()


def find_features(post):
    words = set(post)
    features = {}
    for w in word_features:
        features[w] = (w in words)
    return features

features_set = [(find_features(post), label) for (post, label) in classified_set]
random.shuffle(features_set)

training_set = features_set[:13]
testing_set = features_set[13:]


classifier = nltk.NaiveBayesClassifier.train(training_set)
accuracy = nltk.classify.accuracy(classifier, testing_set)

print (accuracy)
print (classifier.show_most_informative_features(30))

# save_classifier = open("naivebayesclassifier.pickle", "wb")
# pickle.dump(classifier, save_classifier)