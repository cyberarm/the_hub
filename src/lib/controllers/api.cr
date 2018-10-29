get "/api" do |env|
"
ENDPOINTS
  * /api/systems
  * /api/web-servers
  * /api/game-servers
  * /api/sensors-iot
"
end

get "/api/systems" do |env|
  env.response.content_type = "application/json"

  list = [] of String
  Monitoring.instance.system_monitors.each {|m| list << m.to_json}
  "[#{list.join(",")}]"
end

get "/api/web-servers" do |env|
  env.response.content_type = "application/json"

  list = [] of String
  Monitoring.instance.web_server_monitors.each {|m| list << m.to_json}
  "[#{list.join(",")}]"
end

get "/api/game-servers" do |env|
  env.response.content_type = "application/json"

  list = [] of String
  Monitoring.instance.game_server_monitors.each {|m| list << m.to_json}
  "[#{list.join(",")}]"
end

get "/api/sensors-iot" do |env|
  env.response.content_type = "application/json"

  list = [] of String
  Monitoring.instance.sensor_iot_monitors.each {|m| list << m.to_json}
  "[#{list.join(",")}]"
end

post "/api/sensors-iot/update" do |env|
  env.params
end