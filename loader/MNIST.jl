module MNIST

export MNISTData, MNIST_loaddata

# info and files at http://yann.lecun.com/exdb/mnist/
TEST_DATA = "data/t10k-images.idx3-ubyte"
TEST_LABELS = "data/t10k-labels.idx1-ubyte"
TRAINING_DATA = "data/train-images.idx3-ubyte"
TRAINING_LABELS = "data/train-labels.idx1-ubyte"

LABEL_MAGICNUMBER = 2049
DATA_MAGICNUMBER = 2051

MNISTIMAGE_WIDTH = 28
MNISTIMAGE_HEIGHT = 28

type MNISTData
	trainingsize::Int32
	trainingdata::SparseMatrixCSC{Float64, Int64}
	traininglabel::Vector{Int8}

	testsize::Int32
	testdata::SparseMatrixCSC{Float64, Int64}	
	testlabel::Vector{Int8}

	MNISTData() = new(	0, 
						Matrix(0,0),
						Vector(0), 
						0, 
						Matrix(0,0),
						Vector(0)		)
end

# Flip the endianness of a 32 bit unsigned integer
flip(x) = ((x << 24) | ((x & 0xff00) << 8) | ((x >> 8) & 0xff00) | (x >> 24))

function MNIST_loaddata( data::MNISTData )
	println("")
	lflag = dflag = false
	if load_data(data, TRAINING_DATA) 
		println("[Julia-MNIST] Training data loaded.")
		if load_labels( data, TRAINING_LABELS )
			println("[Julia-MNIST] Training labels loaded.")
			dflag = true
		end
	else
		println("[Julia-MNIST] ^^ Skipping loading of training labels. Training labels not loaded.")
	end

	if load_data(data, TEST_DATA)
		println("[Julia-MNIST] Test data loaded.")
		if load_labels( data, TEST_LABELS )
			println("[Julia-MNIST] Test labels loaded.")
			lflag = true
		end
	else
		println("[Julia-MNIST] ^^ Skipping loading of test labels. Test labels not loaded.")
	end

	(dflag && lflag) ? println("\n[Julia-MNIST] All data and labels loaded successfully.") : println("\n[Julia-MNIST] Incomplete loading. Dataset not complete.")


end

#Function loads MNIST training data from TEST_DATA into data.testdata
# where data.testdata is a Matrix
function load_data( data::MNISTData, filename::ASCIIString )
	if filename == TEST_DATA || filename == TRAINING_DATA
		if !isfile( filename ) 
			if filename == TRAINING_DATA 
				println("[Julia-MNIST] Could not locate training data file. Training data not loaded.")
			elseif filename == TEST_DATA
				println("[Julia-MNIST] Could not locate test data file. Test data not loaded.") 
			end
			return false
		end

		open( filename ) do datafile
			if filename == TRAINING_DATA
				println("[Julia-MNIST] Loading training data...")
			elseif filename == TEST_DATA
				println("[Julia-MNIST] Loading test data...")
			end

			if DATA_MAGICNUMBER != flip( read(datafile, UInt32) )
				println("[Julia-MNIST] !!ERROR!! Format error detected in data file. Ensure file is valid.")
				return false
			end

			if filename == TRAINING_DATA
				datasize = data.trainingsize = flip( read(datafile,UInt32) )
			elseif filename == TEST_DATA
				datasize = data.testsize = flip( read(datafile,UInt32) )
			end

			MNISTIMAGE_HEIGHT = flip( read(datafile, UInt32) )
			MNISTIMAGE_WIDTH = flip( read(datafile, UInt32) )
		
			dense_data = Array(Float64, MNISTIMAGE_HEIGHT * MNISTIMAGE_WIDTH, datasize)
			read_densedata( datafile, dense_data )

			if filename == TRAINING_DATA
				data.trainingdata = sparse( dense_data )
			elseif filename == TEST_DATA
				data.testdata = sparse( dense_data )
			end
			return true
		end
	else
		println("[Julia-MNIST] Data filename does not match any path specified in MNIST.jl. Specify incoming path names in MNIST.jl.")
		return false
	end
end 

# For loading pixel matricies from data files
function read_densedata( datafile::IOStream, matrix::Matrix{Float64} )
	for i = 1:size(matrix, 2)
		for j = 1:size(matrix, 1)
			matrix[j,i] = read(datafile, UInt8)
		end
	end
end

#Function loads the solutions to the training data set into the MNISTData container
function load_labels(data::MNISTData, filename::ASCIIString )
	if filename == TEST_LABELS || filename == TRAINING_LABELS
		if !isfile( filename )
			if filename == TRAINING_LABELS
				println("[Julia-MNIST] Could not locate training label file. Training labels not loaded.")
			elseif filename == TEST_LABELS
				println("[Julia-MNIST] Could not locate test label file. Test labels not loaded.") 
			end
			return false
		end

		open( filename ) do datafile
			if filename == TRAINING_LABELS
				println("[Julia-MNIST] Loading training labels...")
			elseif filename == TEST_LABELS
				println("[Julia-MNIST] Loading test labels...")
			end

			if LABEL_MAGICNUMBER != flip(read(datafile, UInt32))
				println("[Julia-MNIST] !!ERROR!! Format error detected in training label file. Ensure data file is valid.")
				return false
			end

			if filename == TRAINING_LABELS
				samesize = ( data.trainingsize == flip( read(datafile, UInt32) ) )
			elseif filename == TEST_LABELS
				samesize = ( data.testsize == flip( read(datafile, UInt32) ) )
			end

			if samesize 
				if filename == TRAINING_LABELS
					data.traininglabel = Array(Int8, data.trainingsize)
					read_labelvector( datafile, data.traininglabel )
				elseif filename == TEST_LABELS
					data.testlabel = Array(Int8, data.testsize)
					read_labelvector( datafile, data.testlabel )
				end
				return true
			else
				println("[Julia-MNIST] !!ERROR!! Data set size does not match solution set size.  Labels not loaded.")
				return false
			end
		end
	else
		println("[Julia-MNIST] Label filename does not match any path specified in MNIST.jl. Specify incoming path names in MNIST.jl.")
		return false
	end
end

# For loading solution vector from label files
function read_labelvector( datafile::IOStream , vector::Vector{Int8} )
	for i = 1:size(vector,1)
		vector[i] = read(datafile, UInt8)
	end
end

end