class GameServerMonitor < Monitor
  getter :domain

  def initialize(name : String, update_interval : Float32, domain : String)
    @domain = domain
    super(name, update_interval)
  end

  def report
    "N/A"
  end
end

require "./game_monitors/*"
