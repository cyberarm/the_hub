get "/admin" do |env|
  page_title = "Admin"
  monitoring = Monitoring.instance
  render "./src/views/admin/index.slang", "./src/views/admin/admin_layout.slang"
end

get "/admin/monitors" do |env|
  page_title = "Monitors | Admin"
  monitoring = Monitoring.instance
  render "./src/views/admin/monitors/index.slang", "./src/views/admin/admin_layout.slang"
end

get "/admin/monitors/:monitor" do |env|
  monitor = Monitoring.instance.monitors[env.params.url["monitor"].to_i]
  page_title = "#{monitor.name} | Monitors | Admin"
  render "./src/views/admin/monitors/show.slang", "./src/views/admin/admin_layout.slang"
end

get "/admin/accounts" do |env|
  page_title = "Accounts | Admin"
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

  if username.downcase == FriendlyConfig.config.not_nil!.admin["username"].downcase
    if check_password(FriendlyConfig.config.not_nil!.admin["password"], password_from_form)
      cookie = HTTP::Cookie.new("authentication_token", Session.instance.create_session)
      cookie.http_only = true
      env.response.cookies["authentication_token"] = cookie
      env.redirect "/"
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

def check_password(password_hash : String, password_from_form : String)
  if Crypto::Bcrypt::Password.new(password_hash) == password_from_form
    return true
  else
    return false
  end
end