using SOM
using Base.Test

# Tests are using Iris dataset:
#
Pkg.add("RDatasets")
using RDatasets
iris = dataset("datasets", "iris")
train = iris[:,1:4]

include("testTrain.jl")


# test hexagonal, rectangular and spherical training:
#
@test testTrain(train, :hexagonal, toroidal = false)
@test testTrain(train, :rectangular, toroidal = false)
@test testTrain(train, :spherical, toroidal = false)

# test toroidal:
#
@test testTrain(train, :rectangular, toroidal = true)

# test visual:
#
@test testVisual(train, :rectangular, toroidal = false)
