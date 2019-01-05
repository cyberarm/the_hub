puts "HI"

class Model
  class Monitor < Granite::Base
    adapter sqlite

    field name : String
    field type : String
    field domain : String
    field update_interval : Float32
    field key : String
  end
end

Model::Monitor.migrator.drop_and_create
puts "0x00"
