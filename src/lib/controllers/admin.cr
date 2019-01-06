def get_monitor(model_id)
  Monitoring.instance.monitors.find {|m| m.model_id == model_id}
end

get "/admin" do |env|
  page_title = "Admin"
  monitors = Model::Monitor.all
  accounts   = Model::User.all
  render "./src/views/admin/index.slang", "./src/views/admin/admin_layout.slang"
end

get "/admin/monitors" do |env|
  page_title = "Monitors | Admin"
  monitors = Model::Monitor.all
  render "./src/views/admin/monitors/index.slang", "./src/views/admin/admin_layout.slang"
end

get "/admin/monitors/new" do |env|
  page_title = "Add Monitor | Admin"
  monitoring = Monitoring.instance
  render "./src/views/admin/monitors/new.slang", "./src/views/admin/admin_layout.slang"
end
post "/admin/monitors/new" do |env|
  name = env.params.body["name"].as(String)
  type = env.params.body["type"].as(String)
  domain = env.params.body["domain"].as(String)
  update_interval = env.params.body["update_interval"].to_f
  game = env.params.body["game"].as(String)

  m = Model::Monitor.create(name: name, type: type, domain: domain, update_interval: update_interval, game: game)
  if m
    Monitoring.instance.add_monitor(m)
    env.redirect "/admin/monitors/#{m.id}"
  else
    env.redirect "/admin/monitors/new"
  end
end

get "/admin/monitors/:monitor" do |env|
  monitor = Model::Monitor.find(env.params.url["monitor"].to_i)

  if monitor
    page_title = "#{monitor.not_nil!.name.not_nil!} | Monitors | Admin"
    render "./src/views/admin/monitors/show.slang", "./src/views/admin/admin_layout.slang"
  else
    halt(env, status_code: 404)
  end
end

get "/admin/monitors/:monitor/edit" do |env|
  monitor = Model::Monitor.find(env.params.url["monitor"].to_i)
  if monitor
    page_title = "#{monitor.not_nil!.name.not_nil!} | Monitors | Admin"
    render "./src/views/admin/monitors/edit.slang", "./src/views/admin/admin_layout.slang"
  else
    halt(env, status_code: 404)
  end
end

get "/admin/monitors/:monitor/delete" do |env|
  monitor = Model::Monitor.find(env.params.url["monitor"].to_i)
  if monitor
    if monitor.destroy
      Monitoring.instance.delete_monitor(monitor.id)
      env.redirect "/admin/monitors"
    else
      halt(env, status_code: 500)
    end
  else
    halt(env, status_code: 404)
  end
end

get "/admin/accounts" do |env|
  page_title = "Accounts | Admin"
  accounts = Model::User.all
  render "./src/views/admin/accounts/index.slang", "./src/views/admin/admin_layout.slang"
end

get "/admin/sign-in" do |env|
  page_title = "Sign In | Admin"
  hub_message = nil
  if env.request.cookies["hub_message"]? && env.request.cookies["hub_message"].value.size > 0
    hub_message = env.request.cookies["hub_message"].value
    env.response.cookies["hub_message"] = ""
  end

  render "./src/views/admin/sign_in.slang", "./src/views/admin/admin_layout.slang"
end

post "/admin/sign-in" do |env|
  username = env.params.body["username"].as(String)
  password_from_form = env.params.body["password"].as(String)

  user = Model::User.find_by(username: username.downcase)

  if user && username.downcase == user.username.not_nil!
    if check_password(user.password.not_nil!, password_from_form)
      Session.instance.create_session(env, user.id.not_nil!, env.request.host.not_nil!)
    else
      cookie = HTTP::Cookie.new("hub_message", "Username or password was incorrect!")
      cookie.http_only = true
      env.response.cookies["hub_message"] = cookie

      env.redirect "/admin/sign-in"
    end
  else
    cookie = HTTP::Cookie.new("hub_message", "Username or password was incorrect!")
    cookie.http_only = true
    env.response.cookies["hub_message"] = cookie

    env.redirect "/admin/sign-in"
  end
end

get "/admin/sign-out" do |env|
  session = Session.instance.destroy_session(env.request.cookies["authentication_token"].value)
  if session
    env.response.cookies["authentication_token"] = ""
  end
  env.redirect "/"
end

def bcrypt_password(password)
  Crypto::Bcrypt::Password.create(password)
end

def check_password(password_hash : String|Nil, password_from_form : String)
  if Crypto::Bcrypt::Password.new(password_hash) == password_from_form
    return true
  else
    return false
  end
end