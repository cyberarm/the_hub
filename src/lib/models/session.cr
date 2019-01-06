class Model
  class Session < Granite::Base
    adapter sqlite

    field user_id : Int64
    field token : String

    field user_ip : String

    validate_not_blank :user_id
    validate_not_blank :token
    validate_not_blank :user_ip
    timestamps
  end
end
