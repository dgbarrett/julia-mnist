using Base.Test

include("../src/MNIST.jl")
importall MNIST

println("\nTesting data import...")
data = MNIST_getdata()
println("\nData import testing done.")

test_handler( r::Test.Success ) = println("Test passed.")
test_handler( r::Test.Failure ) = error("Test failed: $(r.expr)")
test_handler( r::Test.Error ) = rethrow(r)

println("\n\n\nVerifiying data...\n")

Test.with_handler(test_handler) do
	train = data.trainingsize
	test = data.testsize
	@test MNIST_iscomplete( data ) 

	println("\nTesting TRAINING dataset...")
	@test data.trainingdata[159,1] == 0xAF
	@test data.trainingdata[160,1] == 0x1A
	@test data.trainingdata[161,1] == 0xA6
	@test data.trainingdata[655,train] == 0xDE
	@test data.trainingdata[656,train] == 0xF4
	@test data.trainingdata[657,train] == 0x2C

	@test data.traininglabel[1] == 5
	@test data.traininglabel[2] == 0
	@test data.traininglabel[3] == 4
	@test data.traininglabel[train - 2] == 5
	@test data.traininglabel[train - 1] == 6
	@test data.traininglabel[train] == 8
	println("Done dataset.\n")

	println("Testing TEST dataset...")
	@test data.testdata[203,1] == 84
	@test data.testdata[204,1] == 185
	@test data.testdata[205,1] == 159
	@test data.testdata[606,test] == 132
	@test data.testdata[607,test] == 110
	@test data.testdata[608,test] == 4

	@test data.testlabel[1] == 7
	@test data.testlabel[2] == 2
	@test data.testlabel[3] == 1
	@test data.testlabel[test - 2] == 4
	@test data.testlabel[test - 1] == 5
	@test data.testlabel[test] == 6

	println("Done dataset.\n")

end

println("\nData verification done.")
println("\n\nTests done.")