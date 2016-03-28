module MNIST

export MNISTData, load_testdata

TEST_DATA = "data/t10k-images.idx3-ubyte"
TEST_LABELS = ""
TRAINING_DATA = ""
TRAINING_LABELS = ""

# http://yann.lecun.com/exdb/mnist/

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
						Array(Float64, 0,0),
						[], 
						0, 
						Array(Float64, 0,0),
						[]		)
end

#flip the endianness of a number
flip(x) = ((x << 24) | ((x & 0xff00) << 8) | ((x >> 8) & 0xff00) | (x >> 24))


#load the test data from file
function load_testdata(data::MNISTData)
	open(TEST_DATA) do datafile
		#For running on Intel type platform, must flip endianess of data
		magic_num = flip(read(datafile, UInt32))

		if magic_num != data.DATA_MAGICNUMBER
			println("Error detected in test data file.  Check paths in MNIST.jl are correct.")
			return nothing
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

end