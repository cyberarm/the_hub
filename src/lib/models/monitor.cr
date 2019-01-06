class Model
  class Monitor < Granite::Base
    adapter sqlite

    field name : String
    field type : String
    field domain : String
    field update_interval : Float32
    field game : String
    field key : String

    timestamps
  end
end