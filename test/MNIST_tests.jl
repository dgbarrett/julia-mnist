using Base.Test

include("../loader/MNIST.jl")
importall MNIST

data = MNIST_getdata()

@test MNIST_iscomplete( data ) 
@test data.testdata[203,1] == 84