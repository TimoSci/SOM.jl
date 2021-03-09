
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
include("../src/namesPreprocessor.jl")


# include("benchmark.jl")

function generate_integer_hash_function(a,b,cardinality)
    # cardinality must be prime number
    # a,b: 1 ≤ a ≤ p−1  , 0 ≤ b ≤ p−1
    @assert a < cardinality
    @assert a > 0
    @assert b < cardinality
    @assert b >= 0
    @assert isprime(cardinality)
    m = cardinality
    x -> (x^a%m + b)%m  #TODO use modular exponentiation
end

function generate_vector_deterministic_pseudorandom(seed,hash_func,dimension)
    [hash_func(x+seed) for x in 1:dimension]
end

function generate_dataset(number,dimension,max_value,y=(x->x))
    # dimension = 16
    # max_value = 1013
    params = Dict(:a => 13, :b => 17, :hash_seed => 23, :prime => 1013)
    hash_func = generate_integer_hash_function(params[:a],params[:b],params[:prime])

    seed = params[:hash_seed]
    matrix = zeros((number,dimension))
    for i in 1:number
        vector = generate_vector_deterministic_pseudorandom(seed,hash_func,dimension)
        vector = map((x->x*max_value/params[:prime]),vector)
        vector = map((x->(x+max_value)/2),vector)
        vector = map(y,vector)
        seed = hash_func(seed+i)
        matrix[i,:] = vector
    end
    convert(DataFrame,matrix)
end





function benchmark_init(train, topol; toroidal = false,
                    normType = :zscore)

    xdim = 40
    ydim = 40

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

#


# train = copy(names_data)
#
# virgin_som = benchmark_init(train, :rectangular, toroidal = true)
# som = benchmark_train(virgin_som,train)

 # train = generate_dataset(1000,10,1)

 # som = benchmark_init(train, :rectangular, toroidal = true)
 # som = benchmark_train(som,train)


# test hexagonal, rectangular and spherical training:
#
# @time benchmarkTrain(train, :hexagonal, toroidal = false)
# @time benchmarkTrain(train, :rectangular, toroidal = false)
# @time benchmarkTrain(train, :spherical, toroidal = false)
