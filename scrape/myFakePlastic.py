from __future__ import print_function
import nltk.classify.util
from nltk.classify import NaiveBayesClassifier
from nltk.corpus import movie_reviews
import json

# nltk.download('movie_reviews')

# print(type(movie_reviews))

negids = movie_reviews.fileids("neg")
posids = movie_reviews.fileids("pos")

# movie_reviews.categories()

print(len(negids))
print(len(posids))


def word_feats(words):
    return dict([(word, True) for word in words])


posfeats = [(word_feats(movie_reviews.words(fileids=[f])), 'pos') for f in posids]

negfeats = [(word_feats(movie_reviews.words(fileids=[f])), 'neg') for f in negids]

poscutoff = len(posfeats) * 3 / 4
negcutoff = len(negfeats) * 3 / 4

trainfeats = negfeats[:negcutoff] + posfeats[:poscutoff]
testfeats = negfeats[negcutoff:] + posfeats[poscutoff:]

print('Training on %d training examples and testing on %d training examples' % (len(trainfeats), len(testfeats)))

classifier = NaiveBayesClassifier.train(trainfeats)
print('accuracy:', nltk.classify.util.accuracy(classifier, testfeats))

# with open('temp_fake.txt', 'w') as temp_writer:
#     json.dump(trainfeats, temp_writer)

classifier.show_most_informative_features()
classifier.labels()


##################################

