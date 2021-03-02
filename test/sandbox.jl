
include("../src/SOM.jl")
# using SOM


# using Test
#

using Distances
using ProgressMeter
using StatsBase
using Distributions
using NearestNeighbors
#using TensorToolbox
using LinearAlgebra

using PyPlot
using PyCall


using DataFrames
using RDatasets
using Primes

include("../src/errors.jl")

include("../src/types.jl")
include("../src/helpers.jl")
include("../src/grids.jl")
include("../src/kernels.jl")
include("../src/soms.jl")
include("../src/api.jl")

include("../src/plotTerminal.jl")

include("testFuns.jl")

include("../src/mongo.jl")

include("benchmark.jl")







function benchmark_init(train, topol; toroidal = false,
                    normType = :zscore)

    xdim = 10
    ydim = 10

    initSOM(train, xdim, ydim, norm = normType,
                  topol = topol, toroidal = toroidal)
end

function benchmark_train(som,train, kernel = gaussianKernel)

    return trainSOM(som, train, 20000, kernelFun = kernel)
end




# query = generate_dataset(1000,4,1)
# query = generate_dataset(10000,4,3,x->x+1)
# iris = dataset("datasets", "iris")
# train = iris[:,1:4]
# #

# auto = dataset("ISLR","Auto")
# train = auto[:,1:7]


# train = copy(names_data)
#
# virgin_som = benchmark_init(train, :rectangular, toroidal = true)
# som = benchmark_train(virgin_som,train)

 train = generate_dataset(2000,100,1)
 som = benchmark_init(train, :rectangular, toroidal = true)
 som = benchmark_train(som,train)


# test hexagonal, rectangular and spherical training:
#
# @time benchmarkTrain(train, :hexagonal, toroidal = false)
# @time benchmarkTrain(train, :rectangular, toroidal = false)
# @time benchmarkTrain(train, :spherical, toroidal = false)
