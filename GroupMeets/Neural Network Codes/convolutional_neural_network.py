__author__ = 'saisagarjinka'

import theano
import theano.tensor as T
import numpy as np


class convolutional_network:
    def __init__(self, layers):
        self.layers = layers

        # self.params = [[layer.weights, layer.bias] for layer in layers]
        self.vars = [var for layer in self.layers for var in layer.vars]

        self.x = T.matrix('x')
        self.y = T.ivector('y')

        initial_layer = self.layers[0]
        initial_layer.perform(self.x)
        for j in xrange(1, len(self.layers)):
            prev_layer, layer = self.layers[j - 1], self.layers[j]
            layer.perform(prev_layer.output_drop_out)

    def train_model(self,
                    training_data,
                    training_labels,
                    testing_data,
                    testing_labels,
                    epochs,
                    mini_batch,
                    learning_rate=0.1,
                    regularization_par=0.0):
        num_batches = training_data.get_value().shape[0] / mini_batch
        num_test_batches = testing_data.get_value().shape[0] / mini_batch
        regularization = sum([(layer.weights ** 2).sum() for layer in self.layers])
        train_cost = self.layers[-1].cost_fn(self) + 0.5 * regularization_par * regularization / num_batches
        #print 'WTF'
        # print "Train cost " + str(self.vars.__len__())
        g_W = T.grad(cost=train_cost, wrt=self.vars)
        updates = [(param, param - learning_rate * gradient)
                   for param, gradient in zip(self.vars, g_W)]

        index = T.lscalar()
        train = theano.function(
            inputs=[index],
            outputs=train_cost,
            updates=updates,
            givens={
                self.x:
                    training_data[index * mini_batch: (index + 1) * mini_batch],
                self.y:
                    training_labels[index * mini_batch: (index + 1) * mini_batch]
            }
        )

        test = theano.function(
            inputs=[index],
            outputs=self.layers[-1].accuracy(self.y),
            givens={
                self.x:
                    testing_data[index*mini_batch : (index+1)*mini_batch],
                self.y:
                    testing_labels[index*mini_batch : (index+1)*mini_batch]
            }
        )

        for epoch in range(epochs):
            training_epoch_cost = 0
            testing_epoch_cost = 0
            # num_batches
            for i in range(num_batches):
                #print i
                cost_per_batch = train(i)
                training_epoch_cost = training_epoch_cost + cost_per_batch
                #testing_batch_cost = test(i)
                # testing_epoch_cost += testing_batch_cost
            test_accuracy = np.mean(
                                [test(j) for j in xrange(num_test_batches)])
            print "Training Accuracy for epoch " + str(epoch) + " is " + str(training_epoch_cost)
            print "Testing Accuracy for epoch " + str(epoch) + " is " +str(test_accuracy)
            print "..........................................."
