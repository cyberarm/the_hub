class Model
  class Monitor < Granite::Base
    connection sqlite
    table monitors

    has_many :reports

    column id : Int64, primary: true
    column name            : String
    column type            : String
    column update_interval : Float32
    column domain          : String?
    column game            : String?
    column key             : String?

    column save_reports : Bool = false
    column max_reports  : Int32 = 0

    column reports_count : Int32 = 0

    column last_error : String = ""

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
