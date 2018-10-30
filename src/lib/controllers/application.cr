before_all do |env|
  if authenticated?(env) || env.request.path.includes?("/admin/sign-in") || env.request.path.includes?("/css/application.css")
    next
  else
    env.redirect "/admin/sign-in"
  end
end

get "/" do |env|
  monitors = Monitoring.instance
  if is_xhr?(env)
    render "./src/views/home/index.slang"
  else
    render "./src/views/home/index.slang", "./src/views/application.slang"
  end
end

get "/systems" do |env|
  monitors = Monitoring.instance.system_monitors
  if is_xhr?(env)
    render "./src/views/home/systems.slang"
  else
    render "./src/views/home/systems.slang", "./src/views/application.slang"
  end
end

get "/web-servers" do |env|
  monitors = Monitoring.instance.web_server_monitors
  if is_xhr?(env)
    render "./src/views/home/web_servers.slang"
  else
    render "./src/views/home/web_servers.slang", "./src/views/application.slang"
  end
end

get "/game-servers" do |env|
  monitors = Monitoring.instance.game_server_monitors
  if is_xhr?(env)
    render "./src/views/home/game_servers.slang"
  else
    render "./src/views/home/game_servers.slang", "./src/views/application.slang"
  end
end

get "/sensors" do |env|
  monitors = Monitoring.instance.sensor_iot_monitors
  if is_xhr?(env)
    render "./src/views/home/sensors.slang"
  else
    render "./src/views/home/sensors.slang", "./src/views/application.slang"
  end
end

get "/css/application.css" do
  Sass.compile_file "./src/views/application.sass"
end

def is_xhr?(env)
  begin
    return true if env.request.headers["X-XHR"] == "xmlhttprequest"
  rescue KeyError
    return false
  end
end

def authenticated?(env)
  if env.request.cookies["authentication_token"]? && env.request.cookies["authentication_token"].value == "yes"
    puts "Authenticated!"
    return true
  else
    puts "Not Authenticated!"
    return false
  end
end