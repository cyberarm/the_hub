class MinecraftMonitor < GameServerMonitor
  @mc_pinger : MCPing::Ping
  @mc_ping : MCPing::Ping::PingResponse?

  getter :ping

  def initialize(name : String, update_interval : Float32, domain : String)
    super(name, update_interval, domain)

    split = @domain.split(":")
    if split.size > 1
      host = split.first
      port = split.last.to_u32
      @mc_pinger = MCPing::Ping.new(host, port)
    else
      @mc_pinger = MCPing::Ping.new(@domain)
    end
    @mc_ping = nil
  end

  def query
    begin
      @mc_ping = @mc_pinger.ping
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
    if @mc_ping
      if @up
        return "<img src='#{@mc_ping.not_nil!.favicon}'></img><br/>Uptime #{formatted_uptime}<br/>#{@mc_ping.not_nil!.description.text}<br/>Players #{@mc_ping.not_nil!.players.online}/#{@mc_ping.not_nil!.players.max}"
      else
        return "Downtime #{formatted_downtime}"
      end
    else
      return "N/A"
    end
  end

  def mini_status
    if @mc_ping && @up
      "#{@mc_ping.not_nil!.players.online}/#{@mc_ping.not_nil!.players.max}"
    else
      ""
    end
  end

  def to_hash
    orginal_hash = super.to_h
    hash = {} of String => String | Int32

    if @up && @mc_ping
      hash["description"] = @mc_ping.not_nil!.description.text

      hash["numplayers"] = @mc_ping.not_nil!.players.online
      hash["maxplayers"] = @mc_ping.not_nil!.players.max
    end

    orginal_hash.merge(hash)
  end
end
