class Monitor
  property :name, :up, :uptime, :downtime, :last_error, :model_id, :check_monitor, :has_run, :last_checked_time
  getter :update_interval, :ping
  @model_id : Int64

  def initialize(name : String, update_interval : Float32)
    @name = name
    @up = false
    @uptime = Time.monotonic
    @downtime = Time.monotonic
    @last_error = ""
    @ping = 0.0

    @has_run = false
    @last_checked_time = Time.monotonic
    @update_interval = update_interval # seconds between checks

    @model_id = 0
    @check_monitor = true
    @save_reports = false

    setup
  end

  def setup
  end

  def check
  end

  def sync(model : Model::Monitor) # Sync with Database regarding name, domain, ect.
    @name = model.name.not_nil!
    @update_interval = model.update_interval.not_nil!
    @save_reports = model.save_reports.not_nil!
  end

  def save_report
    return unless @save_reports

    report = Model::Report.new(monitor_id: @model_id, payload: self.to_json)
    if report.save
    else
      puts "Failed to save report for #{self.class}=>#{@name}"
    end

    prune_reports
  end

  # FIXME: This is *VERY* inefficient
  def prune_reports
    monitor = Model::Monitor.find(@model_id)
    if monitor
      count = monitor.reports_count.not_nil!
      max_reports = monitor.max_reports.not_nil!

      return if max_reports == Model::Report::INFINITE_REPORTS # Don't delete reports when told to preserve them all

      if count > max_reports
        reports = Model::Report.order(created_at: :desc).where(monitor_id: @model_id)

        index = 0
        reports.each do |report|
          if index > max_reports
            report.destroy
          end

          index += 1
        end
      end
    end
  end

  def mini_status
    ""
  end

  def uptime
    Time.monotonic - @uptime
  end

  def formatted_uptime
    "#{uptime.days}d #{uptime.hours}h #{uptime.minutes}m #{uptime.seconds}s"
  end

  def downtime
    Time.monotonic - @downtime
  end

  def formatted_downtime
    "#{downtime.days}d #{downtime.hours}h #{downtime.minutes}m #{downtime.seconds}s"
  end

  def to_hash
    {name: @name, up: @up, uptime: uptime.to_f, downtime: downtime.to_f, last_error: @last_error, last_checked_time: @last_checked_time.to_f}
  end

  # Hash -> JSON expected
  def to_json
    to_hash.to_json
  end
end

require "./monitors/*"
