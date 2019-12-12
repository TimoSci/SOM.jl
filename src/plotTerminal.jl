using Crayons
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

function color_rectangle(io::IO = stdout)
    println(io, "Color cube, 6×6×6 (16..231):")
    for c in 16:231
        # str = codes ? string(lpad(c, 3, '0'), " ") : "██"
        str = "██"
        print(io, Crayon(foreground = c), str, Crayon(reset = true))
        (c - 16) %  6 ==  5 && println(io)
        (c - 16) % 36 == 35 && println(io)
    end
end
