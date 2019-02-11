import urllib
import pandas as pd

import re, nltk
import scipy
from sklearn.feature_extraction.text import CountVectorizer
from nltk.stem.porter import PorterStemmer

test_data_url = "https://dl.dropboxusercontent.com/u/8082731/datasets/UMICH-SI650/testdata.txt"
train_data_url = "https://dl.dropboxusercontent.com/u/8082731/datasets/UMICH-SI650/training.txt"

test_data_f = urllib.urlretrieve(test_data_url, 'test_data.txt')
train_data_f = urllib.urlretrieve(train_data_url, 'train_data.txt')

test_data_df = pd.read_csv('test_data.txt', header=None, delimiter="\t", quoting=3)
test_data_df.columns = ["Text"]
train_data_df = pd.read_csv('train_data.txt', header=None, delimiter="\t", quoting=3)
train_data_df.columns = ["Sentiment","Text"]

test_data_df.shape
train_data_df.head()
test_data_df.head()

stemmer = PorterStemmer()
def stem_tokens(tokens, stemmer):
    stemmed = []
    for item in tokens:
        stemmed.append(stemmer.stem(item))
    return stemmed

def tokenize(text):
    # remove non letters
    text = re.sub("[^a-zA-Z]", " ", text)
    # tokenize
    tokens = nltk.word_tokenize(text)
    # stem
    stems = stem_tokens(tokens, stemmer)
    return stems
########

vectorizer = CountVectorizer(
    analyzer = 'word',
    tokenizer = tokenize,
    lowercase = True,
    stop_words = 'english',
    max_features = 85
)

corpus_data_features = vectorizer.fit_transform(
    train_data_df.Text.tolist() + test_data_df.Text.tolist())

corpus_data_features_nd = corpus_data_features.toarray()
corpus_data_features_nd.shape