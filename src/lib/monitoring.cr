class Monitoring
  class MonitorStruct
    JSON.mapping(
      name: String,
      type: String,
      update_interval: Float32?,
      domain: String?,
      game: String?,
      key: String?
    )
  end

  @@singleton = new.as(self)
  def self.instance : Monitoring
    @@singleton
  end


  property :check_monitors
  getter :monitors, :system_monitors, :web_server_monitors, :game_server_monitors, :sensor_iot_monitors
  def initialize
    # All monitors for looping through
    @monitors = [] of Monitor

    # Monitor groups for accessing data easier
    @system_monitors = [] of SystemMonitor
    @web_server_monitors = [] of WebServerMonitor
    @game_server_monitors = [] of GameServerMonitor
    @sensor_iot_monitors = [] of SensorIoTMonitor

    @check_monitors = true

    add_monitors("./data/monitors.json")
    run
  end

  def add_monitors(file : String)
    return
    monitors = Array(MonitorStruct).from_json(File.open(file))

    monitors.each do |monitor|
      case monitor.type
      when "system"
        m = SystemMonitor.new(monitor.name)
        @monitors.push(m)
        @system_monitors.push(m)
      when "web"
        m = WebServerMonitor.new(monitor.name, monitor.update_interval.not_nil!, monitor.domain.not_nil!)
        @monitors.push(m)
        @web_server_monitors.push(m)
      when "gameserver"
        case monitor.game
        when "minecraft"
          m = MinecraftMonitor.new(monitor.name, monitor.update_interval.not_nil!, monitor.domain.not_nil!)
          @monitors.push(m)
          @game_server_monitors.push(m)
        when "minetest"
          m = MinetestMonitor.new(monitor.name, monitor.update_interval.not_nil!, monitor.domain.not_nil!)
          @monitors.push(m)
          @game_server_monitors.push(m)
        when "cncrenegade"
          m = CNCRenegadeMonitor.new(monitor.name, monitor.update_interval.not_nil!, monitor.domain.not_nil!)
          @monitors.push(m)
          @game_server_monitors.push(m)
        end
      when "sensor"
        m = SensorIoTMonitor.new(monitor.name, monitor.update_interval.not_nil!)
        @monitors.push(m)
        @sensor_iot_monitors.push(m)
      end
    end
  end

  def run
    @monitors.each do |monitor|
      spawn do
        while @check_monitors
          if monitor.has_run
            if ((Time.monotonic - monitor.last_checked_time).to_i < monitor.update_interval)
            else
              monitor.check
            end
          else
            monitor.check
          end

          sleep 0.1
        end
      end
    end
  end
end