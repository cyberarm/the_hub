class Monitoring

  property :check_monitors
  getter :monitors, :monitor_types, :monitor_game_types

  def self.monitor_types
    {
      "web":    "Web Server",
      "game":   "Game Server",
      "sensor": "Sensor or IOT",
      "system": "System",
    }
  end

  def self.monitor_type_keys : Array
    Monitoring.monitor_types.keys.map { |k| k.to_s }
  end

  def self.monitor_game_types
    {
      "cncrenegade": "Command & Conquer: Renegade",
      "minecraft":   "Minecraft",
      "minetest":    "mintest",
    }
  end

  @@instance = new.as(self)
  def self.instance : Monitoring
    @@instance
  end

  private def initialize
    # All monitors for looping through
    @monitors = [] of Monitor

    @check_monitors = true

    add_monitors
  end

  def web_server_monitors : Array(WebServerMonitor)
    monitors = [] of WebServerMonitor
    @monitors.map { |m| if m.is_a?(WebServerMonitor)
      m
    end }.each do |monitor|
      monitors << monitor if monitor
    end

    return monitors
  end

  def system_monitors : Array(SystemMonitor)
    monitors = [] of SystemMonitor
    @monitors.map { |m| if m.is_a?(SystemMonitor)
      m
    end }.each do |monitor|
      monitors << monitor if monitor
    end

    return monitors
  end

  def game_server_monitors : Array(GameServerMonitor)
    monitors = [] of GameServerMonitor
    @monitors.map { |m| if m.is_a?(GameServerMonitor)
      m
    end }.each do |monitor|
      monitors << monitor if monitor
    end

    return monitors
  end

  def sensor_iot_monitors : Array(SensorIoTMonitor)
    monitors = [] of SensorIoTMonitor
    @monitors.map { |m| if m.is_a?(SensorIoTMonitor)
      m
    end }.each do |monitor|
      monitors << monitor if monitor
    end

    return monitors
  end

  def add_monitors
    monitors = Model::Monitor.all

    if monitors
      monitors.each do |monitor|
        add_monitor(monitor)
      end
    end
  end

  def add_monitor(monitor) # : Model::Monitor
    m = nil

    case monitor.type
    when "system"
      m = SystemMonitor.new(monitor.name.not_nil!)
    when "web"
      m = WebServerMonitor.new(monitor.name.not_nil!, monitor.update_interval.not_nil!, monitor.domain.not_nil!)
    when "game"
      case monitor.game.not_nil!
      when "minecraft"
        m = MinecraftMonitor.new(monitor.name.not_nil!, monitor.update_interval.not_nil!, monitor.domain.not_nil!)
      when "minetest"
        m = MinetestMonitor.new(monitor.name.not_nil!, monitor.update_interval.not_nil!, monitor.domain.not_nil!)
      when "cncrenegade"
        m = CNCRenegadeMonitor.new(monitor.name.not_nil!, monitor.update_interval.not_nil!, monitor.domain.not_nil!)
      end
    when "sensor"
      m = SensorIoTMonitor.new(monitor.name.not_nil!, monitor.update_interval.not_nil!)
    end

    if m
      m.model_id = monitor.id.not_nil!
      m.sync(monitor)
      @monitors.push(m)

      run(m)
    end
  end

  def sync_monitor(monitor_db_model : Model::Monitor)
    monitor = get_monitor(monitor_db_model.id)
    if monitor
      monitor.sync(monitor_db_model)
    end
  end

  def delete_monitor(monitor_model_id)
    monitor = get_monitor(monitor_model_id)
    if monitor
      @monitors.delete(monitor)
    end
  end

  def run(monitor)
    spawn do
      while @check_monitors
        break unless get_monitor_object(monitor)

        if monitor.has_run
          if ((Time.monotonic - monitor.last_checked_time).to_i < monitor.update_interval)
          else
            begin
              monitor.check
              monitor.save_report
            rescue e
              monitor.up = false
              monitor.last_checked_time = Time.monotonic
              monitor.last_error = e.to_s
              puts "#{monitor.name} encountered an error: #{e}"
            end
          end
        else
          begin
            monitor.check
            monitor.save_report
          rescue e
            monitor.up = false
            monitor.has_run = true
            monitor.last_checked_time = Time.monotonic
            monitor.last_error = e.to_s
            puts "#{monitor.name} encountered an error: #{e}"
          end
        end

        sleep 0.1
      end
    end
  end

  def get_monitor(model_id : Int64)
    monitors.find { |m| m.model_id == model_id }
  end

  def get_monitor_object(monitor : Monitor)
    monitors.find { |m| m == monitor }
  end
end
