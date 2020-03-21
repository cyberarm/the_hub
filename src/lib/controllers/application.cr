error 404 do
  "<h1 style='text-align: center'>Page Not Found</h1>"
end

get "/" do |env|
  unless authenticated?(env) || allow_dashboard
    env.flash.keep!
    env.redirect "/admin/sign-in"
  end

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
    render "./src/views/game_servers/index.slang"
  else
    render "./src/views/game_servers/index.slang", "./src/views/application.slang"
  end
end

get "/game-servers/:monitor" do |env|
  env.redirect "/" unless authenticated?(env) || allow_basic

  db_monitor = Model::Monitor.find(env.params.url["monitor"].to_i)
  if db_monitor
    page_title = "#{db_monitor.name} | Game Servers"
    if is_xhr?(env)
      render "./src/views/game_servers/show.slang"
    else
      render "./src/views/game_servers/show.slang", "./src/views/application.slang"
    end
  else
    halt(env, status_code: 404)
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
  Hub::STYLESHEET
end

def is_xhr?(env)
  env.request.headers["X-XHR"]? == "xmlhttprequest"
end

# HTML Checkboxes are hard, this makes it easier
def checkbox_boolean(checkbox_string)
  boolean = false

  case checkbox_string.to_s
  when "on"
    boolean = true
  when "off"
    boolean = false
  when "1"
    boolean = true
  when "0"
    boolean = false
  when "nil"
    boolean = false
  end

  return boolean
end

# Does the visitor have a valid session cookie?
def authenticated?(env)
  if env.request.cookies["authentication_token"]? && Session.valid_session?(env.request.cookies["authentication_token"].value, true)
    cookie = env.request.cookies["authentication_token"]
    cookie.expires = Time.utc + FriendlyConfig::EXPIRE_SESSION_AFTER # n hours in future
    env.response.cookies["authentication_token"] = cookie
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
  cookie = env.request.cookies["authentication_token"]?

  if cookie
    session = Model::Session.find_by(token: cookie.value)

    begin
      return Model::User.find(session.not_nil!.user_id).not_nil!
    rescue
      return nil
    end
  else
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