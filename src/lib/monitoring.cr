class Monitoring
  class MonitorStruct
    JSON.mapping(
      name: String,
      type: String,
      update_interval: Float32,
      domain: String,
      game: String,
      key: String
    )
  end

  @@singleton = new.as(self)
  def self.instance : Monitoring
    @@singleton
  end


  getter :monitors
  def initialize
    @monitors = [] of Monitor
    @check_monitors = true

    add_monitors("./data/monitors.json")
    run
  end

  def add_monitors(file : String)
    monitors = Array(MonitorStruct).from_json(File.open(file))

    monitors.each do |monitor|
      case monitor.type
      when "web"
        @monitors.push(WebServerMonitor.new(monitor.name, monitor.update_interval, monitor.domain))
      when "gameserver"
        @monitors.push(GameServerMonitor.new(monitor.name, monitor.update_interval))
      when "sensor"
        @monitors.push(SensorIoTMonitor.new(monitor.name, monitor.update_interval))
      end
    end
  end

  def run
    spawn do
      while @check_monitors
        @monitors.each do |monitor|
          if monitor.has_run
            if ((Time.monotonic - monitor.last_checked_time).to_i < monitor.update_interval)
              next
            end
          end

          monitor.check
        end
        sleep 0.1
      end
    end
  end
end