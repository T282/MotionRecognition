__author__ = 'saisagarjinka'
import pandas
import numpy
from keras.models import Sequential
from keras.layers import Dense

dataframe = pandas.read_csv("/Users/saisagarjinka/Downloads/DeepLearningTraining/housing.csv", delim_whitespace=True,
                            header=None)
dataset = dataframe.values
X = dataset[:, 0:13]
Y = dataset[:, 13]


def baseline_model():
    # creating model here
    model = Sequential()
    model.add(Dense(13, input_dim=13, init='normal', activation='relu'))
    model.add(Dense(1, init='normal'))
    '''
    model = Sequential([
    Dense(13, input_dim=13),
    Activation('relu'),
    Dense(1)
    ])
    '''

    # After create compile here
    model.compile(loss='mean_squared_error', optimizer='adam')
    print model.summary()
    return model

model = baseline_model()
model.fit(X, Y, nb_epoch=100, batch_size=5)