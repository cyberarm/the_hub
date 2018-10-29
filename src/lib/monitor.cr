class Monitor
  property :name, :up, :uptime, :downtime, :last_error
  getter :last_checked_time, :update_interval, :has_run
  def initialize(name : String, update_interval : Float32)
    @name = name
    @up = false
    @uptime = Time.monotonic
    @downtime = Time.monotonic
    @last_error = ""

    @has_run = false
    @last_checked_time = Time.monotonic
    @update_interval = update_interval # seconds between checks

    setup
  end

  def setup
  end

  def check
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

  def to_json
    JSON.dump({name: @name, up: @up, uptime: uptime, downtime: downtime, last_error: @last_error, last_checked_time: @last_checked_time})
  end
end

require "./monitors/*"