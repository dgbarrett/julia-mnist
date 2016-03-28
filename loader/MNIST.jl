module MNIST

export MNISTData, MNIST_loaddata

# info and files at http://yann.lecun.com/exdb/mnist/
TEST_DATA = "data/t10k-images.idx3-ubyte"
TEST_LABELS = "data/t10k-labels.idx1-ubyte"
TRAINING_DATA = "data/train-images.idx3-ubyte"
TRAINING_LABELS = "data/train-labels.idx1-ubyte"

MNIST_LABEL_FILE_MAGIC_NUMBER = 2049
MNIST_DATA_FILE_MAGIC_NUMBER = 2051

MNISTIMAGE_WIDTH = 28
MNISTIMAGE_HEIGHT = 28

type MNISTData
	LABEL_MAGICNUMBER::Int32
	DATA_MAGICNUMBER::Int32
	IMG_WIDTH::Int32
	IMG_HEIGHT::Int32

	trainingsize::Int32
	trainingdata::SparseMatrixCSC{Float64, Int64}
	traininglabel::Vector{Int8}

	testsize::Int32
	testdata::SparseMatrixCSC{Float64, Int64}	
	testlabel::Vector{Int8}

	MNISTData() = new(	MNIST_LABEL_FILE_MAGIC_NUMBER, 
						MNIST_DATA_FILE_MAGIC_NUMBER, 
						MNISTIMAGE_WIDTH, 
						MNISTIMAGE_HEIGHT, 
						0, 
						Matrix(0,0),
						Vector(0), 
						0, 
						Matrix(0,0),
						Vector(0)		)
end

# Flip the endianness of a 32 bit unsigned integer
flip(x) = ((x << 24) | ((x & 0xff00) << 8) | ((x >> 8) & 0xff00) | (x >> 24))

function MNIST_loaddata( data::MNISTData )
 	load_trainingdata( data )
	load_traininglabels( data )
	load_testdata( data )
	load_testlabels( data )
end

#Function loads MNIST training data from TRAINING_DATA into data.trainingdata
# where data.trainingdata is a Matrix
function load_trainingdata( data::MNISTData )
	if !isfile( TRAINING_DATA ) 
		println("[Julia-MNIST] !!ERROR!! Could not locate training data file. Training data not loaded.")
		return 
	end

	open(TRAINING_DATA) do datafile
		println("[Julia-MNIST] Loading training data...")

		if data.DATA_MAGICNUMBER != flip( read(datafile, UInt32) )
			println("[Julia-MNIST] !!ERROR!! Format error detected in training data file. Ensure data file is valid.")
			return 
		end

		data.trainingsize = flip( read(datafile, UInt32) )
		data.IMG_HEIGHT = flip( read(datafile, UInt32) )
		data.IMG_WIDTH = flip( read(datafile, UInt32) )
	
		dense_trainingdata = Array(Float64, data.IMG_WIDTH * data.IMG_HEIGHT, data.trainingsize)
		load_data( datafile, dense_trainingdata )

		data.trainingdata = sparse( dense_trainingdata )
	end
end

#Function loads MNIST training data from TEST_DATA into data.testdata
# where data.testdata is a Matrix
function load_testdata( data::MNISTData )
	if !isfile( TEST_DATA ) 
		println("[Julia-MNIST] Could not locate test data file. Test data not loaded.")
		return
	end

	open( TEST_DATA ) do datafile
		println("[Julia-MNIST] Loading test data...")

		if data.DATA_MAGICNUMBER != flip( read(datafile, UInt32) )
			println("[Julia-MNIST] !!ERROR!! Format error detected in test data file. Ensure data file is valid.")
			return 
		end

		data.testsize = flip( read(datafile,UInt32) )
		data.IMG_HEIGHT = flip( read(datafile, UInt32) )
		data.IMG_WIDTH = flip( read(datafile, UInt32) )
	
		dense_testdata = Array(Float64, data.IMG_WIDTH * data.IMG_HEIGHT, data.testsize)
		load_data( datafile, dense_testdata )

		data.testdata = sparse( dense_testdata )
	end
end 

# For loading pixel matricies from data files
function load_data( datafile::IOStream, matrix::Matrix{Float64} )
	for i = 1:size(matrix, 2)
		for j = 1:size(matrix, 1)
			matrix[j,i] = read(datafile, UInt8)
		end
	end
end

#Function loads the solutions to the training data set into the MNISTData container
function load_traininglabels(data::MNISTData)
	if !isfile(TRAINING_LABELS)
		println("[Julia-MNIST] Could not locate training label file. Training labels not loaded.")
		return
	end

	open(TRAINING_LABELS) do datafile
		println("[Julia-MNIST] Loading training labels (solutions)...")

		if data.LABEL_MAGICNUMBER != flip(read(datafile, UInt32))
			println("[Julia-MNIST] !!ERROR!! Format error detected in training label file. Ensure data file is valid.")
			return 
		end

		# If the number of data records matches the number of solutions...
		#  ie. making sure every image has a solution
		if data.trainingsize == flip(read(datafile, UInt32))
			data.traininglabel = Array(Int8, data.trainingsize)
			load_labels( datafile, data.traininglabel )
		else
			println("[Julia-MNIST] !!ERROR!! Training set data size does not correspond to solution set size.")
		end
	end
end

#Function loads the solutions to the test data set into the MNISTData container
function load_testlabels(data::MNISTData)
	if !isfile(TEST_LABELS)
		println("[Julia-MNIST] Could not locate test label file. Test labels not loaded.")
		return
	end

	open(TEST_LABELS) do datafile
		println("[Julia-MNIST] Loading test labels (solutions)...")

		if data.LABEL_MAGICNUMBER != flip(read(datafile, UInt32))
			println("[Julia-MNIST] !!ERROR!! Format error detected in test label file. Ensure data file is valid.")
			return 
		end

		if data.testsize == flip(read(datafile, UInt32))
			data.testlabel = Array(Int8, data.testsize)
			load_labels( datafile, data.testlabel )
		else
			println("[Julia-MNIST] !!ERROR!! Test set data size does not correspond to solution set size.")
		end
	end
end

# For loading solution vector from label files
function load_labels( datafile::IOStream , vector::Vector{Int8} )
	for i = 1:size(vector,1)
		vector[i] = read(datafile, UInt8)
	end
end

end