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
trainingdata::SparseMatrixCSC{Float64, Int64}
#= 
	Sparse (MNISTIMAGE_HEIGHT * MNISTIMAGE_WIDTH) by trainingsize (784x60000 default) matrix holding training images as column vectors.
	** Sparse matricies are accessed like any other matrix type in Julia.
=#
```

```julia
testdata::SparseMatrixCSC{Float64, Int64}
#= 
	Sparse (MNISTIMAGE_HEIGHT * MNISTIMAGE_WIDTH) by testsize (784x10000 default) matrix holding test images as column vectors.
=#
```

```julia
traininglabel::Vector{Int8}
#= 
	Solutions to trainingdata.  traininglabel[i] corresponds to the solution for column vector i in trainingdata.
=#
```

```julia
testlabel::Vector{Int8}
#= 
	Solutions to testdata.  testlabel[i] corresponds to the solution for column vector i in testdata.
=#
```

```julia
completeload::Bool
#= 
	True if data object is completely loaded.  False if there were errors loading when loading datasets.
=#



Functions
---------

### MNIST_getdata()

Return type
```julia
MNISTData
```

Creates and loads a MNISTData object from the file paths specified by TEST_DATA, TEST_LABELS, etc.., in MNIST.jl before returning the object to the user.  Any errors loading the data are printed to STDOUT.


### MNIST_iscomplete( ::MNISTData )

Return type
```julia
Bool
```

Returns true if the MNISTData object is completley loaded and suffered no errors reading the data/labels into its internal structures.  Returns false if the data/labels are incomplete, assume the data contained in such a case is erroneous.




