Julia-MNIST
===========

Purpose
-------

A Julia module for loading/containing the MNIST dataset. 


Usage
-----

The user must first download the MNIST data files from http://yann.lecun.com/exdb/mnist/ and place them in the data directory.

To use the module in your code:

```julia
importall MNIST
```

To initialize a MNISTData object (the container type which holds the loaded data) and load data into it, do the following:

```julia
# returns loaded object of type ::MNISTData
data = MNIST_getdata() 
```

