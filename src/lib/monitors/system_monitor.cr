class SystemMonitor < Monitor
  getter :net_download, :net_upload, :cpu, :memory

  @net_old_in : Int64
  @net_old_out : Int64
  @net_now_in : Int64
  @net_now_out : Int64
  @net_download : Int64
  @net_upload : Int64

  def initialize(name : String)
    super(name, 1)
    @cpu = Hardware::CPU.new
    @memory = Hardware::Memory.new
    @net = Hardware::Net.new
    @net_old_in, @net_old_out = @net.in_octets, @net.out_octets
    @net_now_in, @net_now_out = @net.in_octets, @net.out_octets

    @net_download = 0
    @net_upload = 0
  end

  def check
    @last_checked_time = Time.monotonic

    @net = Hardware::Net.new
    @net_now_in, @net_now_out = @net.in_octets, @net.out_octets

    @net_download = (@net_now_in - @net_old_in) * 8 # Bytes to bits
    @net_upload = (@net_now_out - @net_old_out) * 8

    @net_old_in, @net_old_out = @net_now_in, @net_now_out

    @up = true
  end

  def formatted_net_download
    if @net_download >= (1000*1000*1000) # Gb
      n = (@net_download / 1000.0 / 1000.0 / 1000.0).round(2)
      return "#{n} Gb/s"
    elsif @net_download >= (1000*1000) # Mb
      n = (@net_download / 1000.0 / 1000.0).round(2)
      return "#{n} Mb/s"
    elsif @net_download >= (1000) # Kb
      n = (@net_download / 1000.0).round(2)
      return "#{n} Kb/s"
    else
      return "#{@net_download} b/s"
    end
  end

  def formatted_net_upload
    if @net_upload >= (1000*1000*1000) # Gb
      n = (@net_upload / 1000.0 / 1000.0 / 1000.0).round(2)
      return "#{n} Gb/s"
    elsif @net_upload >= (1000*1000) # Mb
      n = (@net_upload / 1000.0 / 1000.0).round(2)
      return "#{n} Mb/s"
    elsif @net_upload >= (1000) # kb
      n = (@net_upload / 1000.0).round(2)
      return "#{n} Kb/s"
    else
      return "#{@net_upload} b/s"
    end
  end

  def to_hash
    {
      name:              @name,
      up:                @up,
      uptime:            uptime.to_f,
      downtime:          downtime.to_f,
      last_error:        @last_error,
      last_checked_time: @last_checked_time.to_f,

      cpu:              @cpu.usage.to_i,
      memory:           @memory.percent.to_i,
      memory_available: @memory.available,
      memory_used:      @memory.used,
      memory_total:     @memory.total,
      net_download:     @net_download,
      net_upload:       @net_upload,
    }
  end
end
