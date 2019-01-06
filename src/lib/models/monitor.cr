class Model
  class Monitor < Granite::Base
    adapter sqlite

    field name : String
    field type : String
    field update_interval : Float32
    field domain : String
    field game : String
    field key : String

    field last_error : String

    validate_not_blank :name
    validate_not_blank :type
    validate_not_blank :update_interval

    validate_uniqueness :name

    validate_is_valid_choice :type, ["web", "system", "game", "sensor"]

    validate_min_length :name, 1
    validate_min_length :type, 1

    timestamps
  end
end