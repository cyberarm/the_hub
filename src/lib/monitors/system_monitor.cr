class SystemMonitor < Monitor
  getter :net_download, :net_upload, :cpu, :memory

  @net_old_in  : Int64
  @net_old_out : Int64
  @net_now_in  : Int64
  @net_now_out : Int64
  @net_download: Float64
  @net_upload  : Float64
  def initialize(name : String)
    super(name, 1)
      @cpu    = Hardware::CPU.new
      @memory = Hardware::Memory.new
      @net    = Hardware::Net.new
      @net_old_in, @net_old_out = @net.in_octets, @net.out_octets
      @net_now_in, @net_now_out = @net.in_octets, @net.out_octets

      @net_download = 0
      @net_upload   = 0
  end

  def check
    @last_checked_time = Time.monotonic

    @net = Hardware::Net.new
    @net_now_in, @net_now_out = @net.in_octets, @net.out_octets

    @net_download = ((@net_now_in - @net_old_in) / 1000.0).round(2) #kB/s
    @net_upload   = ((@net_now_out - @net_old_out) / 1000.0).round(2) #kB/s

    @net_old_in, @net_old_out = @net_now_in, @net_now_out

    @up = true
  end
end