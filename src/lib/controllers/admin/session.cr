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
      Session.create_session(env, user.id.not_nil!, env.request.host.not_nil!)
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
  session = Session.destroy_session(env.request.cookies["authentication_token"].value)
  if session
    env.response.cookies["authentication_token"] = ""
  end
  env.redirect "/"
end
