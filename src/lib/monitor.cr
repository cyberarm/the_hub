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

  def downtime
    Time.monotonic - @downtime
  end
end

require "./monitors/*"