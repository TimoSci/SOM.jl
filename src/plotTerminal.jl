using Crayons
# using ColorTypes

function print_density(som::Som)
    population_to_array(som) |> print_greyscale_rectangle
end

function print_density(som::Som,train,neighbors=4)
    train_density_to_array(som::Som,train,neighbors) |> print_greyscale_rectangle
end

function print_colored_text(som::Som,train,row_labels)
    neighbors,_ = nearest_neighbors(som,train,1)
    neighbors = map(x->x[1],neighbors)
    labels = map(x-> row_labels[x] ,neighbors)
    name_array = neuron_attribute_to_array(som,labels)
    color_array = train_density_to_array(som,train)
    print_greyscale_text(name_array,color_array)
end

function print_colored_text_uniq(som::Som,train,row_labels)
    included = []
    neighbors,_ = nearest_neighbors(som,train,10)
    neighbors = map(neighbors) do set
        # print(set)
        i = popfirst!(set)
        while ((i in included) && isempty(set))
            i = popfirst!(set)
        end
        push!(included,i)
        # print(i)
        i
    end
    # neighbors = map(x->x[1],neighbors)
    labels = map(x-> row_labels[x] ,neighbors)
    name_array = neuron_attribute_to_array(som,labels)
    color_array = train_density_to_array(som,train)
    print_greyscale_text(name_array,color_array)
end

"""
Attemps to map each training data row onto a unique neuron.
Row labels most be ordered in order of preference (higher up more likely to
be assigned to nearest neighbor neuron)
"""
function one_to_one_mapping(som::Som,train,row_labels)
    mapping = fill("",som.nCodes)
    neighbors, distances = nearest_neighbors(som::Som,train,16)
    for pair in zip(row_labels,distances)

    end
end

#
#

function train_density_to_array(som::Som,train,neighbors=4)
    densities = train_density(som,train,neighbors)
    neuron_attribute_to_array(som::Som,densities)
end

function population_to_array(som::Som)
    neuron_attribute_to_array(som,som.population)
end


function neuron_attribute_to_array(som::Som,attribute::Array{String})
    xdim, ydim = som.xdim, som.ydim
    a = fill("",xdim,ydim)
    _neuron_attribute_to_array(som::Som,attribute,a)
end

function neuron_attribute_to_array(som::Som,attributes)
    xdim, ydim = som.xdim, som.ydim
    a = zeros(xdim,ydim)
    _neuron_attribute_to_array(som::Som,attributes,a)
end

function _neuron_attribute_to_array(som::Som,attributes,a)
    for n in 1:som.nCodes
        x,y= som.indices[n,1:2]
        a[x,y] = attributes[n]
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

function print_greyscale_text(text_array,data,io::IO = stdout)

    f(x)= x*255 |> floor |> x->convert(Int,x)
    data = normalize01(data)
    data = map(f,data)
    width, height = size(data)

    for i in 1:width
        for j in 1:height
            str = text_array[i,j]
            value = data[i,j]
            print(io, Crayon(; foreground = (value, value, value)), str*" ", Crayon(reset = true))
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
