import nltk
import csv
import pickle
from nltk import word_tokenize
from nltk.corpus import stopwords

stop_words = set(stopwords.words('english'))
stop_words.update( set(line.strip() for line in open('customstopwords.txt')) )

testDataArray = list( csv.reader( open("testdata.csv") ) )
headers = testDataArray.pop(0)
labelHeaders = headers[1:]


testData = []
for row in testDataArray:
   boolRow = [row.pop(0)]
   for label in row:
      boolRow.append( bool(int(label)) )
   testData.append( dict(zip(headers, boolRow)))


classified_set = []
for classifiedPost in testData:

   post = nltk.word_tokenize( classifiedPost["post"] )
   post = [word.lower() for word in post]
   for word in post:
      if word in stop_words:
         post = filter(lambda a: a != word, post)

   for label in labelHeaders:
      if classifiedPost[label]:
         classified_set.append( (post, label) )


print classified_set

# classifier = nltk.NaiveBayesClassifier.train(training_set)
# accuracy = nltk.classify.accuracy(classifier, testing_set)

# save_classifier = open("naivebayesclassifier.pickle", "wb")
# pickle.dump(classifier, save_classifier)