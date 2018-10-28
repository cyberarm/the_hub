require "kemal"

get "/" do
  monitors = Monitoring.instance
  render "./src/views/home/index.slang", "./src/views/application.slang"
end

get "/system" do
  monitors = Monitoring.instance.system_monitors
  render "./src/views/home/system.slang", "./src/views/application.slang"
end

get "/web-servers" do
  monitors = Monitoring.instance.web_server_monitors
  render "./src/views/home/web_servers.slang", "./src/views/application.slang"
end

get "/game-servers" do
  monitors = Monitoring.instance.game_server_monitors
  render "./src/views/home/game_servers.slang", "./src/views/application.slang"
end

get "/sensors" do
  monitors = Monitoring.instance.sensor_iot_monitors
  render "./src/views/home/sensors.slang", "./src/views/application.slang"
end

get "/css/application.css" do
  Sass.compile_file "./src/views/application.sass"
end