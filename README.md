Julia-MNIST
===========

Purpose
-------

A Julia module for loading/containing the MNIST dataset. 


Usage
-----

To use the module in your code:

```julia
importall MNIST
```

To initialize a MNISTData object (the container type which holds the loaded data) and load data into it, do the following:

```julia
data = MNISTData()
MNIST_loaddata(data)
```

