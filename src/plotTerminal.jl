using Crayons
using ColorTypes

# function plotDensity(som::Som)
#
#     # use population form the som itself, if no prediction is given as arg.
#     #
#     if predict == nothing
#         population = som.population
#     else
#         population = makePopulation(som.nCodes, predict.index)
#     end
#
#     if typeof(colormap) == Symbol
#         colormap = string(colormap)
#     end
#
#     if som.topol == :spherical
#         drawSpherePopulation(som, population, detail, title,
#                              paper, colormap, device, fileName)
#     else
#         drawPopulation(som, population, title, paper, colormap, device, fileName)
#     end
# end

const GREY_RANGE = 232:255




function greyscale_rectangle(data,io::IO = stdout)
    # println(io, "Color cube, 6×6×6 (16..231):")

    f(x)= x*255 |> floor |> x->convert(Int,x)
    data = normalize01(data)
    data = map(f,data)
    width = 10
    height = 10

    str = "██"
    for i in 1:width
        for j in 1:height
            value = data[i,j]
            print(io, Crayon(; foreground = (value, value, value)), str, Crayon(reset = true))
       end
       print("\n")
    end

end

function normalize01(data)
    min,max = minimum(data),maximum(data)
    factor = max-min
    f(x)=(x-min)/factor
    map(f,data)
end
