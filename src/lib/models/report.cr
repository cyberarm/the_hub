class Model
  class Report < Granite::Base
    adapter sqlite
    table_name :reports

    belongs_to :monitor

    field monitor_id : Int64
    field payload : String


    validate_not_blank :monitor_id
    validate_not_blank :payload
    timestamps
  end
end
