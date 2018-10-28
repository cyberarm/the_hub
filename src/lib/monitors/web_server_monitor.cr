require "halite"

class WebServerMonitor < Monitor
  getter :domain
  def initialize(name : String, update_interval : Float32, domain : String)
    super(name, update_interval)
    @domain = domain
  end

  def check_connection
    begin
      return Halite.follow.timeout(connect: 3.0, read: 5.0).head(domain)
    rescue Halite::Exception::ConnectionError
      @up = false
      @last_error = "ConnectionError"
      return nil
    end
  end

  def check
    @has_run    = true
    connection = check_connection
    @last_checked_time = Time.monotonic

    if connection
      if connection.status_code >= 200 && connection.status_code <= 299
        @uptime = Time.monotonic unless @up
        @up = true
        return true
      else
        @last_error = connection.status_code.to_s
        @up = false
        return false
      end
    else
      @up = false
    end
  end
end