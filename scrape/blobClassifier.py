from textblob import TextBlob

import Eve

from textblob.classifiers import NaiveBayesClassifier
from nltk.corpus import movie_reviews
import random

reviews = [(list(movie_reviews.words(fileid)), category)
           for category in movie_reviews.categories()
           for fileid in movie_reviews.fileids(category)]

new_train, new_test = reviews[1000:2000], reviews[501:800]

cl = NaiveBayesClassifier(new_train)

accuracy = cl.accuracy(new_test)
print("Accuracy: {0}".format(accuracy))

print(cl.classify("amazing host! Loved it"))

print(cl.accuracy(new_test))

blob = TextBlob("amazing.", classifier=cl)

print(blob)
print(blob.classify())



