import nltk
import csv
import pickle
import random
import sklearn
from nltk import word_tokenize
from nltk.corpus import stopwords

stop_words = set(stopwords.words('english'))
stop_words.update( set(line.strip() for line in open('customstopwords.txt')) )