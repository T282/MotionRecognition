__author__ = 'saisagarjinka'

import numpy as np
import theano.tensor as T
import theano
import numpy

x = theano.tensor.matrix('x')
y = theano.tensor.matrix('y')
z = x + y
f = theano.function(inputs = [x, y], outputs = [z])
output = f([[1, 2, 3]], [[4, 5, 6]])
print output


x = theano.tensor.matrix('x')
y = theano.shared( numpy.array([[4, 5, 6]]))
z = x + y
f = theano.function(inputs = [x], outputs = [z])
output = f([[1, 2, 3]])


print output
