class Model
  class Session < Granite::Base
    connection sqlite
    table sessions

    belongs_to :user

    column id : Int64, primary: true
    column user_id : Int64
    column token   : String

    column user_ip : String

    validate_not_blank :user_id
    validate_not_blank :token
    validate_not_blank :user_ip
    timestamps
  end
end
