get "/" do |env|
  env.redirect "/admin/sign-in" unless authenticated?(env) || allow_dashboard

  page_title = "Overview"
  monitors = Monitoring.instance
  if is_xhr?(env)
    render "./src/views/home/index.slang"
  else
    render "./src/views/home/index.slang", "./src/views/application.slang"
  end
end

get "/systems" do |env|
  env.redirect "/" unless authenticated?(env) || allow_basic

  page_title = "Systems"
  monitors = Monitoring.instance.system_monitors
  if is_xhr?(env)
    render "./src/views/home/systems.slang"
  else
    render "./src/views/home/systems.slang", "./src/views/application.slang"
  end
end

get "/web-servers" do |env|
  env.redirect "/" unless authenticated?(env) || allow_basic

  page_title = "Web Servers"
  monitors = Monitoring.instance.web_server_monitors
  if is_xhr?(env)
    render "./src/views/home/web_servers.slang"
  else
    render "./src/views/home/web_servers.slang", "./src/views/application.slang"
  end
end

get "/game-servers" do |env|
  env.redirect "/" unless authenticated?(env) || allow_basic

  page_title = "Game Servers"
  monitors = Monitoring.instance.game_server_monitors
  if is_xhr?(env)
    render "./src/views/home/game_servers.slang"
  else
    render "./src/views/home/game_servers.slang", "./src/views/application.slang"
  end
end

get "/sensors" do |env|
  env.redirect "/" unless authenticated?(env) || allow_basic

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
  env.request.headers["X-XHR"]? == "xmlhttprequest"
end

# Does the visitor have a valid session cookie?
def authenticated?(env)
  if env.request.cookies["authentication_token"]? && Session.valid_session?(env.request.cookies["authentication_token"].value)
    return true
  else
    return false
  end
end

# TODO: Implement DB backed config for this
# boolean - permit any visitor to access basic dashboard?
def allow_dashboard
  return false
end

# TODO: Implement DB backed config for this
# boolean - permit any visitor to access monitors? (does not allow /admin access)
def allow_basic
  return false
end

# Return Model::User object or Nil if no user was found
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