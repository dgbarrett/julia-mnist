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
	trainingdata::Matrix{Float64}
	traininglabel::Vector{Int8}

	testsize::Int32
	testdata::Matrix{Float64}	
	testlabel::Vector{Int8}

	MNISTData() = new(	MNIST_LABEL_FILE_MAGIC_NUMBER, 
						MNIST_DATA_FILE_MAGIC_NUMBER, 
						MNISTIMAGE_WIDTH, 
						MNISTIMAGE_HEIGHT, 
						0, 
						Matrix(0,0),
						[], 
						0, 
						Matrix(0,0),
						[]		)
end

#flip the endianness of a number
flip(x) = ((x << 24) | ((x & 0xff00) << 8) | ((x >> 8) & 0xff00) | (x >> 24))

function MNIST_loaddata(data::MNISTData)
	load_testdata(data)
	load_trainingdata(data)
	load_traininglabels(data)
end

#Function loads MNIST training data from TRAINING_DATA into data.trainingdata
# where data.trainingdata is a Matrix
function load_trainingdata(data::MNISTData)
	if !isfile(TRAINING_DATA) 
		println("[Julia-MNIST] !!ERROR!! Could not locate training data file. Training data not loaded.")
		return
	end

	open(TRAINING_DATA) do datafile
		println("[Julia-MNIST] Loading training data...")
		magic_num = flip(read(datafile, UInt32))

		if magic_num != data.DATA_MAGICNUMBER
			println("[Julia-MNIST] !!ERROR!! Format error detected in training data file. Ensure data file is valid.")
			return nothing
		end

		data.trainingsize = flip(read(datafile, UInt32))
		data.IMG_HEIGHT = flip(read(datafile, UInt32))
		data.IMG_WIDTH = flip(read(datafile, UInt32))
	
		data.trainingdata = Array(Float64, data.IMG_WIDTH * data.IMG_HEIGHT, data.trainingsize)

		for i = 1:data.trainingsize
			for j = 1:(data.IMG_WIDTH*data.IMG_HEIGHT)
				byte = read(datafile, UInt8)

				if byte != 0
					flip(byte)
				end

				data.trainingdata[j,i] = byte
			end
		end
	end
end

 
#Function loads MNIST training data from TEST_DATA into data.testdata
# where data.testdata is a Matrix
function load_testdata(data::MNISTData)
	if !isfile(TEST_DATA) 
		println("[Julia-MNIST] Could not locate test data file. Test data not loaded.")
		return
	end

	open(TEST_DATA) do datafile
		println("[Julia-MNIST] Loading test data...")
		magic_num = flip(read(datafile, UInt32))

		if magic_num != data.DATA_MAGICNUMBER
			println("[Julia-MNIST] !!ERROR!! Format error detected in test data file. Ensure data file is valid.")
			return 
		end

		data.testsize = flip(read(datafile, UInt32))
		data.IMG_HEIGHT = flip(read(datafile, UInt32))
		data.IMG_WIDTH = flip(read(datafile, UInt32))
	
		data.testdata = Array(Float64, data.IMG_WIDTH * data.IMG_HEIGHT, data.testsize)

		for i = 1:data.testsize
			for j = 1:(data.IMG_WIDTH*data.IMG_HEIGHT)
				byte = read(datafile, UInt8)

				if byte != 0
					flip(byte)
				end

				data.testdata[j,i] = byte
			end
		end
	end
end 

function load_traininglabels(data::MNISTData)
	if !isfile(TRAINING_LABELS)
		println("[Julia-MNIST] Could not locate training label file. Test data not loaded.")
		return
	end

	open(TRAINING_LABELS) do datafile
		println("[Julia-MNIST] Loading training labels (solutions)...")
		magic_num = flip(read(datafile, UInt32))

		if magic_num != data.LABEL_MAGICNUMBER
			println("[Julia-MNIST] !!ERROR!! Format error detected in training label file. Ensure data file is valid.")
			return 
		end

		if data.trainingsize != flip(read(datafile, UInt32))
			println("[Julia-MNIST] !!ERROR!! Training set data size does not correspond to solution set size.")
		end

		data.traininglabel = Array(Int8, data.trainingsize)

		for i = 1 : data.trainingsize
			byte = read(datafile, UInt8)

			if byte != 0
				flip(byte)
			end

			data.traininglabel[i] = byte
		end
	end
end

end