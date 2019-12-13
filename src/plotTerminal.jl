using Crayons
# using ColorTypes

function print_density(som::Som)
    population_to_array(som) |> print_greyscale_rectangle
end

function population_to_array(som)
    xdim, ydim = som.xdim, som.ydim
    a = zeros(xdim,ydim)
    for n in 1:som.nCodes
        x,y= som.indices[n,1:2]
        a[x,y] = som.population[n]
    end
    return a
end

function print_greyscale_rectangle(data,io::IO = stdout)

    f(x)= x*255 |> floor |> x->convert(Int,x)
    data = normalize01(data)
    data = map(f,data)
    width, height = size(data)

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
