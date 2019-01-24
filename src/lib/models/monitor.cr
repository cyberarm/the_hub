class Model
  class Monitor < Granite::Base
    adapter sqlite
    table_name :monitors

    has_many :reports

    field name            : String
    field type            : String
    field update_interval : Float32
    field domain          : String
    field game            : String
    field key             : String

    field save_reports : Bool
    field max_reports  : Int32

    field reports_count : Int32

    field last_error : String

    validate_not_blank :name
    validate_not_blank :type
    validate_not_blank :update_interval

    validate_uniqueness :name

    validate_is_valid_choice :type, ["web", "system", "game", "sensor"]

    validate_min_length :name, 1
    validate_min_length :type, 1

    timestamps

    before_create :set_reports_count

    def set_reports_count
      @reports_count = 0
    end
  end
end
