before_all("/admin") do |env|
  if authenticated?(env) || env.request.path.includes?("/admin/sign-in")
    if admin?(env)
      next
    else
      halt(env, status_code: 401)
    end
  else
    env.redirect "/admin/sign-in"
  end
end

get "/" do |env|
  page_title = "Overview"
  monitors = Monitoring.instance
  if is_xhr?(env)
    render "./src/views/home/index.slang"
  else
    render "./src/views/home/index.slang", "./src/views/application.slang"
  end
end

get "/systems" do |env|
  page_title = "Systems"
  monitors = Monitoring.instance.system_monitors
  if is_xhr?(env)
    render "./src/views/home/systems.slang"
  else
    render "./src/views/home/systems.slang", "./src/views/application.slang"
  end
end

get "/web-servers" do |env|
  page_title = "Web Servers"
  monitors = Monitoring.instance.web_server_monitors
  if is_xhr?(env)
    render "./src/views/home/web_servers.slang"
  else
    render "./src/views/home/web_servers.slang", "./src/views/application.slang"
  end
end

get "/game-servers" do |env|
  page_title = "Game Servers"
  monitors = Monitoring.instance.game_server_monitors
  if is_xhr?(env)
    render "./src/views/home/game_servers.slang"
  else
    render "./src/views/home/game_servers.slang", "./src/views/application.slang"
  end
end

get "/sensors" do |env|
  page_title = "Sensors"
  monitors = Monitoring.instance.sensor_iot_monitors
  if is_xhr?(env)
    render "./src/views/home/sensors.slang"
  else
    render "./src/views/home/sensors.slang", "./src/views/application.slang"
  end
end

get "/css/application.css" do |env|
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
  if env.request.cookies["authentication_token"]? && Session.valid_session?(env.request.cookies["authentication_token"].value)
    return true
  else
    return false
  end
end

def current_user(env)
  cookie = env.request.cookies["authentication_token"].value
  session = Model::Session.find_by(token: cookie)

  begin
    return Model::User.find(session.not_nil!.user_id).not_nil!
  rescue
    return nil
  end
end

def admin?(env)
  user = current_user(env)
  if user
    user.role == Model::User::ROLE_ADMIN
  else
    false
  end
end
def mod?(env)
  user = current_user(env)
  if user
    user.role == Model::User::ROLE_MOD
  else
    false
  end
end
def user?(env)
  user = current_user(env)
  if user
    user.role == Model::User::ROLE_USER
  else
    false
  end
end