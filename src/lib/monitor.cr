class Monitor
  property :name, :up, :uptime, :downtime, :last_error, :model_id, :check_monitor
  getter :last_checked_time, :update_interval, :has_run, :ping
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

    setup
  end

  def setup
  end

  def check
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

  # Hash -> JSON expected
  def to_json
    {name: @name, up: @up, uptime: uptime.to_f, downtime: downtime.to_f, last_error: @last_error, last_checked_time: @last_checked_time.to_f}.to_json
  end
end

require "./monitors/*"