class CNCRenegadeMonitor < GameServerMonitor
  def initialize(name : String, update_interval : Float32, domain : String)
    super(name, update_interval, domain)

    @data = {} of String => String
    @players = [] of (Hash(String, String))

    @packets = [] of String

    @socket = UDPSocket.new
    @socket.read_timeout = 5
    addr = @domain.split(":")
    @socket.connect("#{addr[0]}", addr[1].to_i)
  end

  def retrieve_data(request = "status")
    puts "request: #{request}"
    @packets.clear

    start_time = Time.monotonic
    begin
      @socket.send("\\#{request}\\")
      loop do
        data, addr = @socket.receive(4096) # default of 512 was to small, data was being lost.
        @packets << data

        stop_loop = false
        if data.includes?("\\final\\")
          if @packets.size == query_size(data)
            stop_loop = true
          end
        end

        break if stop_loop
      end
    rescue IO::Timeout
      puts "#{self.class}: The Server At '#{@domain}' Did Not Respond In Time (Within 5 Seconds)"
      return false
    end

    parse(@packets)
    return true if @packets.size > 0
  end

  def check
    @has_run = true
    @last_checked_time = Time.monotonic

    if retrieve_data
      @uptime = Time.monotonic unless @up
      @up = true
    else
      @downtime = Time.monotonic if @up
      @up = false
    end
  end

  def report
    if @up
      if @data
        if @data.dig?("numplayers") && @data.dig?("maxplayers")
          "Uptime #{formatted_uptime}<br/>Map #{@data["mapname"]}<br/>Players #{@data["numplayers"]}/#{@data["maxplayers"]}<br/>Time Left #{formatted_timeleft}"
        else
          "Uptime #{formatted_uptime}<br/>Map #{@data["mapname"]}<br/>Time Left #{formatted_timeleft}"
        end
      else
        "Uptime #{formatted_uptime}"
      end
    else
      "Downtime #{formatted_downtime}"
    end
  end

  def full_report
    if @up && @data
      "#{report}<br/><br/>#{formatted_players}"
    else
      report
    end
  end

  def mini_status
    if @up && @data
      "#{@data["numplayers"]}/#{@data["maxplayers"]}" if @data.dig?("numplayers") && @data.dig?("maxplayers")
    end
  end

  def formatted_timeleft
    list = @data["timeleft"].split(".")
    # TODO: Make this count down by using Time::Span
    if list.size == 3
      "#{list[0]}h #{list[1]}m #{list[2]}s"
    else
      list.join(".")
    end
  end

  def formatted_players
    string = ""
    @players.each do |player|
      string = "#{string}<br/><span style=\"color: #{player["team"] == "GDI" ? "orange" : "red"};padding: 10pt\">#{player["player"]}</span></br/>
      team #{player["team"]} score #{player["score"]}<br/>kills #{player["kills"]} deaths #{player["deaths"]}</br>"
    end

    return string
  end

  def parse(packets : Array(String))
    # Sort packets by queryid
    packets.sort_by! {|packet| packet.strip.split("\\").last.split(".").last.to_i}

    hash = {} of String => String
    key = ""

    packets.join.strip.split("\\").each_with_index do |item, index|
      next if index == 0

      if index.odd?
        key = item
      elsif index.even?
        hash[key] = item
      end
    end

    hash.delete("queryid")
    hash.delete("final")

    players = [] of Hash(String, String)
    player = {} of String => String

    player_id = 0
    annoying = false
    annoying_list = [] of Hash(String, String)
    hash.each do |key, value|
      next unless key.includes?("_")

      data = key.split("_")
      hash.delete(key)

      _key = data.first
      begin
        _id  = data.last.to_i
      rescue ArgumentError
        annoying = true
        annoying_list << {"#{key}" => value}
        next
      end

      if _id != player_id
        players << player

        player = {} of String => String
        player_id = _id
      end

      player[_key] = value
    end
    players << player unless annoying || player.size == 0

    # Response is not standard, thus annoying.
    if annoying
      team_id = 0
      _id = 0
      teams  = [] of Hash(String, String)
      player = {} of String => String

      annoying_list.each do |hash|
        hash.each do |key, value|
          _id = key.split("_").last.split("t").last.to_i

          if _id != team_id
            player["id"] = team_id.to_s
            teams << player
            team_id = _id

            player = {} of String => String
          end

          player[key.split("_").first] = value
        end
      end
      player["id"] = _id.to_s
      teams << player
      gdi = "1"
      nod = "0"

      teams.each do |hash|
        hash["player"] = hash["team"]
        if hash["team"] == "GDI"
          gdi = hash["id"]
        elsif hash["team"] == "Nod"
          nod = hash["id"]
        end

        hash["kills"] = "0"
        hash["deaths"] = "0"
      end

      # Repair all player teams
      players.each do |player|
        if player["team"] == gdi
          player["team"] = "GDI"
          teams[gdi.to_i]["kills"] = (teams[gdi.to_i]["kills"].to_i + player["kills"].to_i).to_s
          teams[gdi.to_i]["deaths"] = (teams[gdi.to_i]["deaths"].to_i + player["deaths"].to_i).to_s
        end
        if player["team"] == nod
          player["team"] = "Nod"
          teams[nod.to_i]["kills"] = (teams[nod.to_i]["kills"].to_i + player["kills"].to_i).to_s
          teams[nod.to_i]["deaths"] = (teams[nod.to_i]["deaths"].to_i + player["deaths"].to_i).to_s
        end
      end

      teams.each {|team| players << team}
    end

    @data = hash
    @players = players
    @players.sort_by! {|pl| pl["score"].to_i}
    @players.reverse!
  end

  def query_size(packet)
    queryid = packet.split("\\").last
    packets = (queryid.split(".").last).to_i
    return packets
  end

  def to_hash
    orginal_hash = super.to_h
    hash = {} of String => String | Array(Hash(String, String))

    if @up && @data
      # Copy hash data into @data hash to prevent needing to add another type to @data
      # which would mean littering ifs here and there.
      @data.each do |key, value|
        hash[key] = value
      end
      hash["timeleft"] = formatted_timeleft
    end
    hash["players"] = @players

    orginal_hash.merge(hash)
  end
end
