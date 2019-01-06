class Monitoring
  # class MonitorStruct
  #   JSON.mapping(
  #     name: String,
  #     type: String,
  #     update_interval: Float32?,
  #     domain: String?,
  #     game: String?,
  #     key: String?
  #   )
  # end

  @@singleton = new.as(self)
  def self.instance : Monitoring
    @@singleton
  end


  property :check_monitors
  getter :monitors#, :system_monitors, :web_server_monitors, :game_server_monitors, :sensor_iot_monitors
  def initialize
    # All monitors for looping through
    @monitors = [] of Monitor

    @check_monitors = true

    add_monitors
    run
  end

  def web_server_monitors : Array(WebServerMonitor)
    monitors = [] of WebServerMonitor
    @monitors.map {|m| if m.is_a?(WebServerMonitor); m; end }.each do |monitor|
      monitors << monitor if monitor
    end

    return monitors
  end
  def system_monitors : Array(SystemMonitor)
    monitors = [] of SystemMonitor
    @monitors.map {|m| if m.is_a?(SystemMonitor); m; end }.each do |monitor|
      monitors << monitor if monitor
    end

    return monitors
  end
  def game_server_monitors : Array(GameServerMonitor)
    monitors = [] of GameServerMonitor
    @monitors.map {|m| if m.is_a?(GameServerMonitor); m; end }.each do |monitor|
      monitors << monitor if monitor
    end

    return monitors
  end
  def sensor_iot_monitors : Array(SensorIoTMonitor)
    monitors = [] of SensorIoTMonitor
    @monitors.map {|m| if m.is_a?(SensorIoTMonitor); m; end }.each do |monitor|
      monitors << monitor if monitor
    end

    return monitors
  end

  def add_monitors
    monitors = Model::Monitor.all

    if monitors
      monitors.each do |monitor|
        p monitor.class
        add_monitor(monitor)
      end
    end
  end

  def add_monitor(monitor)# : Model::Monitor
    case monitor.type
    when "system"
      m = SystemMonitor.new(monitor.name.not_nil!)
      m.model_id = monitor.id.not_nil!
      @monitors.push(m)

    when "web"
      m = WebServerMonitor.new(monitor.name.not_nil!, monitor.update_interval.not_nil!, monitor.domain.not_nil!)
      m.model_id = monitor.id.not_nil!
      @monitors.push(m)

    when "gameserver"
      case monitor.game.not_nil!
      when "minecraft"
        m = MinecraftMonitor.new(monitor.name.not_nil!, monitor.update_interval.not_nil!, monitor.domain.not_nil!)
        m.model_id = monitor.id.not_nil!
        @monitors.push(m)

      when "minetest"
        m = MinetestMonitor.new(monitor.name.not_nil!, monitor.update_interval.not_nil!, monitor.domain.not_nil!)
        m.model_id = monitor.id.not_nil!
        @monitors.push(m)

      when "cncrenegade"
        m = CNCRenegadeMonitor.new(monitor.name.not_nil!, monitor.update_interval.not_nil!, monitor.domain.not_nil!)
        m.model_id = monitor.id.not_nil!
        @monitors.push(m)
      end

    when "sensor"
      m = SensorIoTMonitor.new(monitor.name.not_nil!, monitor.update_interval.not_nil!)
      m.model_id = monitor.id.not_nil!
      @monitors.push(m)
    end
  end

  def delete_monitor(monitor_model_id)

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