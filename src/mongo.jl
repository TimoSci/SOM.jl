#TODO remove this module from the SOM app to separate concerns
#
# Module for retrieving and storing SOM data in Mongodb

using Mongoc

client = Mongoc.Client()
database = client["nomisnator-test"]
collection = database["names"]
mynames = Mongoc.find(collection) |> collect
names_short = [ x["name"] for x= mynames if x["stats"]["count"] > 5000 && x["sex"] == "F"]


names_short |> unique!

# println(names_short)




function cache_som(som,train_data,row_labels=[],record_name="default")
   database = client["som-cache"]
   collection = database[record_name]
   # document["codes"] = serialize_2d(som.codes)
   codes = serialize_2d(som.codes)
   for i in 1:length(codes)
      document = Mongoc.BSON()
      document["code"] = [i,codes[i]]
      Mongoc.insert_one(collection,document)
   end
   # document["train_data"] = serialize_2d(train_data)
   # document["row_labels"] = row_labels
end

function serialize_2d(array)
   array = convert(Matrix,array)
   serialized = []
   for i in 1:nrow(array)
      push!(serialized,array[1,:])
   end
   serialized
end

function deserialize2d(array::Array)
   ncols = length(array[1][1])
   out = reshape([],(0,ncols))
   for row in array
      r = reshape(row,(1,ncols))
      out = vcat(out,r)
   end
   out
end

function restore_som(som,set="default")
   database = client["som-cache"]
   collection = database[set]
   # som_object = collection |> Mongoc.find |> collect |> last
   som_object = collection |> Mongoc.find |> collect
   # som_object["codes"]
end


# function cache_test(name)
#    database = client["test"]
#    collection = database["stuff"]
#    document = Mongoc.BSON()
#    document["name"] = name
#    Mongoc.insert_one(collection,document)
# end
#
# function find_test()
#    database = client["test"]
#    collection = database["stuff"]
#    Mongoc.find(collection) |> collect
# end
