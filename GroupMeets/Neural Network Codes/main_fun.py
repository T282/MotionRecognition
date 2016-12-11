from convolutional_neural_network import convolutional_network
from keras.datasets import cifar10
from layers import convolution_layer, softmax_layer, FullyConnectedLayer
import numpy as np
import theano.tensor as T
import theano
import cPickle
import gzip

__author__ = 'saisagarjinka'


def shared(data):
        shared_x = theano.shared(
            np.asarray(data[0], dtype=theano.config.floatX), borrow=True)
        shared_y = theano.shared(
            np.asarray(data[1], dtype=theano.config.floatX), borrow=True)
        return shared_x, T.cast(shared_y, "int32")

f = gzip.open('/Users/saisagarjinka/Downloads/mnist.pkl.gz', 'rb')
training_data, validation_data, test_data = cPickle.load(f)
f.close()
mnist_train, mnist_train_labels = shared(training_data)
mnist_test, mnist_test_labels = shared(test_data)

print training_data[1]
minibatch = 2
conv_layer1 = convolution_layer(rng= np.random.RandomState(23455),
                           filter_shape=(96,1,9,9),#(96,1,9,9)
                           image_shape=(minibatch,1,28,28), #minibatch,1,24,24
                           conv_param={'pad':0, 'stride':1}, pool=0, drop=0.5, maxOutSize=4)
'''
conv_layer2 = convolution_layer(rng=np.random.RandomState(23455),
                                filter_shape=(minibatch, 128, 9,9),
                                image_shape=(minibatch, 48, 20, 20), #minibatch, 48, 16, 16
                                conv_param={'pad':0, 'stride':1}, pool=0, drop=0.5, maxOutSize=0)

conv_layer3 = convolution_layer(rng=np.random.RandomState(23455),
                                filter_shape=(minibatch, 512, 8,8),
                                conv_param={'pad':0, 'stride':1},
                                image_shape=(minibatch, 128, 13, 13), pool=0, drop=0.5, maxOutSize=0) # minibatch, 128, 8, 8
conv_layer4 = convolution_layer(rng=np.random.RandomState(23455),
                                filter_shape=(minibatch, 8,1,1),
                                image_shape=(minibatch,128,6,6), # minibatch,128,1,1
                                conv_param={'pad':0, 'stride':1},
                                pool=0, drop=0.5, maxOutSize=0)
'''
soft_layer = softmax_layer(rng=np.random.RandomState(23455), prev_nodes=19200/2, num_nodes_this=10, mini_batch=minibatch) #50
#layer2 = FullyConnectedLayer(n_in=784, n_out=100)
#layer3 = softmax_layer(rng=np.random.RandomState(23455),prev_nodes=100,num_nodes_this=10)

print "In Main " + str(conv_layer1.weights.get_value().shape)
#net = convolutional_network([conv_layer1, conv_layer2, conv_layer3, conv_layer4, soft_layer])
net = convolutional_network([conv_layer1, soft_layer])
(X_train, y_train), (X_test, y_test) = cifar10.load_data()
training_shared = theano.shared(
    np.asarray(X_train[0:10], dtype=theano.config.floatX), borrow=True)
print "Shared "+str(np.asarray([item for sublist in y_train[0:10] for item in sublist]).shape)

y = [item for sublist in y_train[0:10] for item in sublist]
training_labels_shared = theano.shared(
    np.asarray(y, dtype=theano.config.floatX), borrow=True)
print "Here " + str(training_labels_shared[2:4])
net.train_model(training_data=mnist_train, training_labels=mnist_train_labels,
                testing_data=mnist_test,testing_labels=mnist_test_labels,
                epochs=10,mini_batch=minibatch)




