class MinetestMonitor < GameServerMonitor
  def initialize(name : String, update_interval : Float32, domain : String)
    super(name, update_interval, domain)
    @socket = UDPSocket.new
    split = @domain.split(":")
    if split.size > 1
      host = split.first
      port = split.last.to_u32

      @socket.connect(host, port)
    else
      @socket.connect(@domain, 30000)
    end
    @socket.read_timeout = 5
  end

  def received_response
    # Minetest Protocol 37~
    hello_packet = Slice[0x4f_u8, 0x45_u8, 0x74_u8, 0x03_u8, 0x00_u8, 0x00_u8, 0x00_u8, 0x03_u8, 0xff_u8, 0xdc_u8, 0x01_u8, 0x00_u8, 0x00_u8]

    @socket.write(hello_packet)

    begin
      slice = Bytes.new(16)
      responses = 0
      @socket.read(slice)
      loop do
        @socket.read(slice)
        responses+=1
        break if responses >= 8
      end
      return true
    rescue IO::Timeout
      return false
    end

    return false
  end

  def check
    @has_run = true
    @last_checked_time = Time.monotonic

    if received_response
      @uptime = Time.monotonic unless @up
      @up = true
    else
      @downtime = Time.monotonic if @up
      @up = false
    end
  end

  def report
    if @up
      "Uptime #{formatted_uptime}<br/>Probaby Online"
    else
      "Downtime #{formatted_downtime}"
    end
  end
end