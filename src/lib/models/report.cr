class Model
  class Report < Granite::Base
    INFINITE_REPORTS = 0

    connection sqlite
    table reports

    belongs_to :monitor

    column id : Int64, primary: true
    column monitor_id : Int64
    column payload : String


    validate_not_blank :monitor_id
    validate_not_blank :payload
    timestamps

    after_save :increment_counter_cache
    after_destroy :deincrement_counter_cache

    def increment_counter_cache
      monitor = Model::Monitor.find(@monitor_id)
      if monitor
        count = monitor.reports_count
        count = 0 unless count
        if count
          monitor.update(reports_count: count + 1)
        end
      end
    end

    def deincrement_counter_cache
      monitor = Model::Monitor.find(@monitor_id)
      if monitor
        count = monitor.reports_count
        if count
          monitor.update(reports_count: count - 1)
        end
      end
    end
  end
end
