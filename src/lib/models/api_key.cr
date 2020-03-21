class Model
  class ApiKey < Granite::Base
    connection sqlite
    table api_keys

    belongs_to :user

    column id : Int64, primary: true
    column user_id : Int64
    column token   : String

    column application_name : String
    column last_access_ip   : String = ""

    validate_not_blank :user_id
    validate_not_blank :token
    validate_not_blank :application_name
    timestamps
  end
end
