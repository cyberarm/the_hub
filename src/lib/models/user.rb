puts "BYE"

class Model
  class User < Granite::Base
    adapter sqlite

    field username : String
    field email : String
    field password : String

    field role : Int32
  end
end

Model::User.migrator.drop_and_create