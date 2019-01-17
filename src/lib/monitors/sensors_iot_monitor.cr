class SensorIoTMonitor < Monitor
  getter :payload
  def initialize(name : String, update_interval : Float32)
    super(name, update_interval)

    @payload = {} of String => String
  end
end
