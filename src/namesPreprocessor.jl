using StringDistances
using Clustering

# Functions for preprocessing raw names data in preparation for SOM algorithm


function generate_basis_set(name_list,set_size=1000)
   names_data = distance_matrix(name_list)
   dgram = hclust(Matrix(names_data),linkage= :average)
   cluster_indicies = Clustering.cutree(dgram, k=set_size)
   get_clustroids(name_list,cluster_indicies,set_size)
end

function generate_distance_df(name_list)
   dm = distance_matrix(name_list,my_compare=long_compare)
   df = dm |> DataFrame
   names!(df,Symbol.(name_list))
   copy(df)
end


#--------

function short_compare(a,b)
    1- compare(a,b, DamerauLevenshtein())
end

function long_compare(a,b)
    (
    (1-compare(a,b, DamerauLevenshtein())) *
    (1-compare(a,b, RatcliffObershelp())) *
          dictionaryDistance(a,b)
     )^(1/2)
end


function dictionaryDistance(a,b)
   min,max = minmax(length(a),length(b))
   for i in 1:min
      if a[i] != b[i]
         return 1 - (i-1)/max
      end
   end
   return (max-min)/max
end

#---------------

function distance_matrix(names;my_compare=short_compare)
    l = length(names)
    m = zeros(l,l)
    for i in 1:l
        for j in 1:l
            name1 = names[i]
            name2 = names[j]
            m[i,j] = my_compare(name1,name2)
        end
    end
    m
end


function get_cluster(j,names_list,cluster_indicies)
   out = []
   k=0
   for i in cluster_indicies
      k += 1
      if i == j
        push!(out,names_list[k])
      end
   end
   out
end

function get_clustroids(names_list,cluster_indicies,n=1000)
   out = []
   for i in 1:n
      k = findfirst(x->x==i,cluster_indicies)
      push!(out,names_list[k])
   end
   out
end



function generate_labels(basis_set)
   permutedims(basis_set[:,:],(2,1))
end
