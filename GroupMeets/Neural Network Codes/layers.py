from theano.tensor.nnet import relu
from theano.tensor.nnet import conv2d
from theano.tensor.nnet import softmax
from theano.tensor.signal.pool import pool_2d

import theano
import theano.tensor as T
import numpy as np

__author__ = 'saisagarjinka'

'''
Input:
  - image_shape: Input data of shape (N, C, H, W)
  - filter_shape: Filter weights of shape (F, C, HH, WW)
'''

'''
def maxout(output, maxOutSize):
    max_out = None
    for i in xrange(maxOutSize):
'''


# Input is (F, C, W, H)
def maxout_theano(output, maxOutSize, output_shape):
    output = output.reshape(output_shape)
    resultant_out = theano.shared(np.zeros(((output_shape[0]/maxOutSize), output_shape[1],
                              output_shape[2],output_shape[3])))
    for i in range(0,output_shape[0],maxOutSize):
        for j in range(output_shape[1]):
            max_out = None
            for s in range(maxOutSize):
                if max_out is None:
                    max_out = output[i,j]
                else:
                    max_out = T.maximum(max_out,output[i+s-1,j])
            resultant_out = theano.tensor.set_subtensor(resultant_out[i/maxOutSize, j],max_out)
    return resultant_out


def dropout(rng, values, p):
    if p > 0:
        srng = theano.tensor.shared_randomstreams.RandomStreams(rng.randint(999999))
        mask = srng.binomial(n=1, p=p, size=values.shape, dtype=theano.config.floatX)
        output = values * mask
        return np.cast[theano.config.floatX](1.0 / p) * output
        #return values
    else:
        return values


class convolution_layer(object):
    # Initializes weights and bias of the network
    def __init__(self, rng, filter_shape, image_shape, conv_param, pool=2,
                 activation_fn=relu, drop=0.0, maxOutSize=2):
        self.filter_shape = filter_shape
        self.num_filters = filter_shape[0]
        self.filter_channels = filter_shape[1]
        self.filter_width = filter_shape[2]
        self.filter_height = filter_shape[3]
        self.image_shape = image_shape
        self.num_images = image_shape[0]
        self.image_channels = image_shape[1]
        self.image_width = image_shape[2]
        self.image_height = image_shape[3]
        self.padding = conv_param['pad']
        self.stride = conv_param['stride']
        self.activation_fn = activation_fn
        self.pool = pool
        self.drop = drop
        self.rng = rng
        self.maxOutSize = maxOutSize

        inp_dimension = self.filter_channels * self.filter_height * self.filter_width
        height_af_convol = ((self.image_height + 2 * self.padding - self.filter_height) / self.stride) + 1
        width_af_convol = ((self.image_width + 2 * self.padding - self.filter_width) / self.stride) + 1
        out_dimension = width_af_convol * height_af_convol * self.filter_channels
        # bound = np.sqrt(6 / (inp_dimension + out_dimension))
        bound = out_dimension
        print "Image Shape "
        self.weights = theano.shared(
            np.asarray(rng.uniform(low=-1 / bound, high=1 / bound, size=filter_shape),
                       dtype=theano.config.floatX
                       ),
            borrow=True
        )

        #self.output_shape = (self.filter_shape[0], self.filter_shape[1], height_af_convol, width_af_convol)
        self.output_shape = (self.filter_shape[0], self.image_shape[0], height_af_convol, width_af_convol)
        print "Out put shape "+str(self.output_shape)
        bias = np.zeros((filter_shape[0],), dtype=theano.config.floatX)
        self.bias = theano.shared(value=bias, borrow=True)

        self.vars = [self.weights, self.bias]
        # Convolution done here

    def perform(self, inp):
        # self.inp =inp
        self.inp = inp.reshape(self.image_shape)
        print "In CNN " + str(self.filter_shape)
        out = conv2d(input=self.inp,
                     filters=self.weights,
                     border_mode=self.padding,
                     input_shape=self.image_shape,
                     filter_shape=self.filter_shape)
        if (self.pool != 0):
            pool_out = pool_2d(
                input=out,
                ds=(self.pool, self.pool), ignore_border=True)
        else:
            pool_out = out
        # ToDo: Implement Maxout activation here. Theano has no implementation
        self.output = self.activation_fn(pool_out + self.bias.dimshuffle('x', 0, 'x', 'x'))

        self.output_drop_out = dropout(self.rng, self.output, self.drop)
        #self.output_drop_out = self.output

        if self.maxOutSize > 0:
            self.output_drop_out = maxout_theano(self.output_drop_out, maxOutSize=self.maxOutSize,
                                          output_shape=self.output_shape)


class softmax_layer:
    def __init__(self, rng, prev_nodes, num_nodes_this, mini_batch):
        self.minibatch = mini_batch
        self.prev_nodes = prev_nodes
        self.final_out_nodes = num_nodes_this

        self.weights = theano.shared(
            np.random.rand(prev_nodes, num_nodes_this),
            borrow=True,
            name='weights'
        )
        '''
        self.weights = theano.shared(
            np.zeros((prev_nodes, num_nodes_this), dtype=theano.config.floatX),
            name='weights', borrow=True)
        '''
        self.bias = theano.shared(
            value=np.zeros(
                (num_nodes_this,),
                dtype=theano.config.floatX
            ),
            name='bias',
            borrow=True
        )
        self.vars = [self.weights, self.bias]

    def perform(self, inp):
        # self.input = input.reshape((batch, inp))
        self.input = inp.reshape((self.minibatch, self.prev_nodes))
        print "In Softmax Layer " + str(theano.dot(self.input, self.weights))
        self.output = softmax(theano.dot(self.input, self.weights) + self.bias)

        self.predictions = T.argmax(self.output, axis=1)

    def cost_fn(self, net):
        return -T.mean(T.log(self.output)[T.arange(net.y.shape[0]), net.y])

    def accuracy(self, labels):
        return T.mean(T.eq(labels, self.predictions))


class FullyConnectedLayer(object):
    def __init__(self, rng, n_in, n_out, activation_fn=relu, p_dropout=0.0):
        self.n_in = n_in
        self.n_out = n_out
        self.activation_fn = activation_fn
        self.drop = p_dropout
        self.rng = rng
        # Initialize weights and biases
        self.weights = theano.shared(
            np.asarray(
                np.random.normal(
                    loc=0.0, scale=np.sqrt(1.0 / n_out), size=(n_in, n_out)),
                dtype=theano.config.floatX),
            name='weigths', borrow=True)
        self.bias = theano.shared(
            np.asarray(np.random.normal(loc=0.0, scale=1.0, size=(n_out,)),
                       dtype=theano.config.floatX),
            name='bias', borrow=True)
        self.vars = [self.weights, self.bias]

    def perform(self, inpt):
        self.input = inpt
        self.output = self.activation_fn(
            theano.dot(self.input, self.weights) + self.bias)

        self.predictions = T.argmax(self.output, axis=1)

        self.output_drop_out = dropout(self.rng, self.output, self.drop)
