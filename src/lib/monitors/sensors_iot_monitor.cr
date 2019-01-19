class SensorIoTMonitor < Monitor
  getter :payload, :last_update

  # A Sensor/IoT/Service Monitor, unlike the other monitors, this kind
  #   of monitor sends a request TO The Hub.
  # This type of service is mark as down if the last update is greater
  #   than the update_interval.

  @last_update : Float64
  @next_update : Float64

  def initialize(name : String, update_interval : Float32)
    super(name, update_interval)

    @payload = {} of String => String
    @last_update = Time.monotonic.total_seconds-10
    @next_update = Time.monotonic.total_seconds # How many seconds into the future to expect next update
  end

  def receive(env : HTTP::Context)
    @last_update = Time.monotonic.total_seconds

    status      = env.params.body["status"]?
    message     = env.params.body["message"]?
    next_update = env.params.body["next_update"]?
    payload     = env.params.body["payload"]?

    @status = status.to_i if status
    @message = message if message

    begin
      next unless payload

      data = JSON.parse(payload)
      @payload.clear
      data.as_h.each do |key, value|
        @payload[key.to_s] = value.to_s
      end
    rescue JSON::ParserException
    end

    @next_update = Time.monotonic.total_seconds + next_update.to_f if next_update
  end

  def check
    @has_run = true
    @last_checked_time = Time.monotonic

    if @next_update <= @last_update
      @up = true
    else
      @up = false
    end
  end
end
