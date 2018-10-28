class Monitor
  getter :name, :up, :uptime, :last_error, :last_checked_time, :update_interval, :has_run
  setter :name, :up, :uptime, :last_error
  def initialize(name : String, update_interval : Float32)
    @name = name
    @up = false
    @uptime = Time.monotonic
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
    Time.now - @uptime
  end
end

require "./monitors/*"