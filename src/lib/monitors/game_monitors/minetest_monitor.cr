class MinetestMonitor < GameServerMonitor
  class MinetestServerList
    @@server_list : MinetestServerList?

    def self.server_list
      @@server_list
    end

    def self.server_list=(list : MinetestServerList)
      @@server_list = list
    end

    getter :data

    def initialize(@url : String = "https://servers.minetest.net/list")
      MinetestServerList.server_list = self

      BackgroundTask.new(100.seconds).run do |task|
        begin
          response = Halite.get(@url)
          @data = JSON.parse(response.body)
        rescue Halite::Exception::ConnectionError | Halite::Exception::TimeoutError
          # pp error
        end
      end
    end
  end

  @server : JSON::Any?
  def initialize(name : String, update_interval : Float32, domain : String)
    super(name, update_interval, domain)

    MinetestServerList.new unless MinetestServerList.server_list
  end

  def check
    @has_run = true
    @last_checked_time = Time.monotonic
    server = nil

    if MinetestServerList.server_list && MinetestServerList.server_list.not_nil!.data
      data = MinetestServerList.server_list.not_nil!.data.not_nil!["list"].as_a
      split = @domain.split(":")
      if split.size > 1
        host = split.first
        port = split.last.to_u32

        server = data.find { |server| server["address"] == host && server["port"] == port }
      else
        server = data.find { |server| server["address"] == @domain }
      end

      if server
        @server = server
        @uptime = Time.monotonic unless @up
        @up = true
      else
        @server = nil
        @downtime = Time.monotonic if @up
        @up = false
      end
    end
  end

  def sync(monitor : Model::Monitor)
    super
  end

  def report
    string = ""

    if @up
      if @server
        server = @server.not_nil!

        string += "Uptime #{formatted_uptime}<br/>"
        string += "#{server["description"]}<br/><br/>"
        string += "Players #{server["clients"]}/#{server["clients_max"]}"

        if server["clients"].as_i > 0
          string += "<br/>"
          server["clients_list"].as_a.each do |client|
            string += "#{client}<br/>"
          end
        end
      end

      string
    else
      "Offline"
    end
  end

  def mini_status
    if @up
      if @server
        server = @server.not_nil!

        "#{server["clients"]}/#{server["clients_max"]}"
      end
    else
      "Downtime #{formatted_downtime}"
    end
  end
end
