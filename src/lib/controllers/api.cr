before_all("/api/*") do |env|
  next if env.request.path == "/api" || env.request.path == "/api/"

  puts "Got request form: #{env.request.host} for #{env.request.path}"
  next # TODO: check access token
end

get "/api" do |env|
  env.response.content_type = "text/plain"

  "
ENDPOINTS
  * /api/systems
  * /api/web-servers
  * /api/game-servers
  * /api/sensors
"
end

get "/api/systems" do |env|
  env.response.content_type = "application/json"

  list = [] of String
  Monitoring.instance.system_monitors.each { |m| list << m.to_json }
  "[#{list.join(",")}]"
end

get "/api/web-servers" do |env|
  env.response.content_type = "application/json"

  list = [] of String
  Monitoring.instance.web_server_monitors.each { |m| list << m.to_json }
  "[#{list.join(",")}]"
end

get "/api/game-servers" do |env|
  env.response.content_type = "application/json"

  list = [] of String
  Monitoring.instance.game_server_monitors.each { |m| list << m.to_json }
  "[#{list.join(",")}]"
end
get "/api/game-servers/:id" do |env|
  env.response.content_type = "application/json"

  id = env.params.url["id"].to_i64
  if id
    monitor = Monitoring.instance.get_monitor(id)
    if monitor && monitor.is_a?(GameServerMonitor)
      monitor.to_json
    else
      halt(env, status_code: 404)
    end
  else
    halt(env, status_code: 404)
  end
end

get "/api/sensors" do |env|
  env.response.content_type = "application/json"

  list = [] of String
  Monitoring.instance.sensor_iot_monitors.each { |m| list << m.to_json }
  "[#{list.join(",")}]"
end

post "/api/sensors/update" do |env|
  # UNIQUE MONITOR KEY : String
  # STATUS : Int (http status codes seem fine)
  # Payload : JSON string
  env.params
end
