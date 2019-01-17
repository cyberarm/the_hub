class CNCRenegadeMonitor < GameServerMonitor
  def initialize(name : String, update_interval : Float32, domain : String)
    super(name, update_interval, domain)

    @data = {} of String => String
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
        data, addr = @socket.receive
        @packets << data

        stop_loop = false
        @packets.each do |packet|
          if packet.includes?("\\final\\")
            if @packets.size == query_size(packet)
              stop_loop = true
            end
          end
        end

        break if stop_loop
      end
    rescue IO::Timeout
      puts "#{self.class}: The Server At '#{@domain}' Did Not Respond In Time (Within 5 Seconds)"
      return false
    end

    puts "Got: #{@packets.join}"
    parse(@packets)
    return true if @packets.size > 0
  end

  def check
    @has_run = true
    @last_checked_time = Time.monotonic

    if retrieve_data("status")
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

  def parse(packets : Array(String))
    parsed_hashes = {} of String => String
    packets.each do |packet|
      fields = packet.split("\\")
      keys = [] of String
      values = [] of String

      packet.split("\\")[1..fields.size - 1].each_with_index do |field, i|
        keys << field if i.even?
        values << field if i.odd?
      end

      keys.each_with_index do |key, i|
        begin
          parsed_hashes[key] = values[i]
        rescue IndexError
        end
      end
    end

    @data = parsed_hashes
  end

  def query_size(packet)
    queryid = packet.split("\\").last
    packets = (queryid.split(".").last).to_i
    return packets
  end

  def to_hash
    orginal_hash = super.to_h
    hash = {} of String => String

    if @up && @data
      if @data.dig?("numplayers") && @data.dig?("maxplayers")
        hash["numplayers"] = @data["numplayers"]
        hash["maxplayers"] = @data["maxplayers"]
      end

      hash["mapname"] = @data["mapname"]
      hash["timeleft"] = formatted_timeleft
    end

    orginal_hash.merge(hash)
  end
end
