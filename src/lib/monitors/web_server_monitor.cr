require "halite"

class WebServerMonitor < Monitor
  getter :domain

  def initialize(name : String, update_interval : Float32, domain : String)
    super(name, update_interval)
    @domain = domain
  end

  def check_connection
    start_time = Time.monotonic

    begin
      response = Halite.follow.timeout(connect: 10.0, read: 15.0).head(domain)
      @ping = (Time.monotonic - start_time).total_milliseconds.round(2)
      return response
    rescue Halite::Exception::ConnectionError
      @last_error = "ConnectionError"
      return nil
    rescue Halite::Exception::TimeoutError
      @last_error = "ConnectionTimedOut"
      return nil
    end
  end

  def check
    @has_run = true
    connection = check_connection
    @last_checked_time = Time.monotonic

    if connection
      if connection.status_code >= 200 && connection.status_code <= 299
        @uptime = Time.monotonic unless @up
        @up = true
        return true
      else
        @last_error = connection.status_code.to_s
        @downtime = Time.monotonic if @up
        @up = false
        return false
      end
    else
      @downtime = Time.monotonic if @up
      @up = false
      return false
    end
  end

  def mini_status
    "#{@ping}ms"
  end
end
