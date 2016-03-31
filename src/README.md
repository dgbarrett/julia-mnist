Julia-MNIST API
==================


Types
-----

### MNISTData

#### Fields

```julia
trainingsize::Int32
# Holds the size of the training set.
```

```julia
testsize::Int32
# Holds the size of the test set.
```

```julia
trainingdata::Array{Float64, 2}
#= 
	(MNISTIMAGE_HEIGHT * MNISTIMAGE_WIDTH) by trainingsize (784x60000 default) array
	holding training images as column vectors.
=#
```

```julia
testdata::Array{Float64, 2}
#= 
	(MNISTIMAGE_HEIGHT * MNISTIMAGE_WIDTH) by testsize (784x10000 default) matrix holding
	 test images as column vectors.
=#
```

```julia
traininglabel::Array{Int64, 2}
#= 
	Solutions to trainingdata.  Position i+1 in column vector j signifies a solution of i for image j.
=#
```

```julia
testlabel::Array{Int64, 2}
#= 
	Solutions to testdata.  Position i+1 in column vector j signifies a solution of i for image j.
=#
```

```julia
completeload::Bool
#= 
	True if data object is completely loaded.  False if there were errors loading when loading 
	datasets.
=#
```



Functions
---------

### MNIST_getdata() => ::MNISTData

Creates and loads a MNISTData object from the file paths specified by TEST_DATA, TEST_LABELS, etc.., in MNIST.jl before returning the object to the user.  Any errors loading the data are printed to STDOUT.


### MNIST_iscomplete( ::MNISTData ) => ::Bool

Returns true if the MNISTData object is completley loaded and suffered no errors reading the data/labels into its internal structures.  Returns false if the data/labels are incomplete, assume the data contained in such a case is erroneous.




