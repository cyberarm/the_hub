class Model
  class ApiKey < Granite::Base
    adapter sqlite
    table_name :api_keys

    belongs_to :user

    field user_id : Int64
    field token : String

    field application_name : String
    field last_access_ip : String

    validate_not_blank :user_id
    validate_not_blank :token
    validate_not_blank :application_name
    timestamps
  end
end
