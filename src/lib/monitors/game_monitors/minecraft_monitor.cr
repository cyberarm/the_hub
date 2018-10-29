class MinecraftMonitor < GameServerMonitor

  @pinger : MCPing::Ping
  @ping : MCPing::Ping::PingResponse?

  getter :ping
  def initialize(name : String, update_interval : Float32, domain : String)
    super(name, update_interval, domain)

    split = @domain.split(":")
    if split.size > 1
      host = split.first
      port = split.last.to_u32
      @pinger = MCPing::Ping.new(host, port)
    else
      @pinger = MCPing::Ping.new(@domain)
    end
    @ping = nil
  end

  def query
    begin
      @ping = @pinger.ping
      return true
    rescue ex
      return false
    end
  end

  def check
    @has_run = true
    @last_checked_time = Time.monotonic

    if query
      @uptime = Time.monotonic unless @up
      @up = true
    else
      @downtime = Time.monotonic if @up
      @up = false
    end

    return @up
  end

  def report
    if @ping
      if @up
        return "<img src='#{@ping.not_nil!.favicon}'></img><br/>Uptime #{formatted_uptime}<br/>#{@ping.not_nil!.description.text}<br/>Players #{@ping.not_nil!.players.online}/#{@ping.not_nil!.players.max}"
      else
        return "Downtime #{formatted_downtime}"
      end
    else
      return "N/A"
    end
  end
end