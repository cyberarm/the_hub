get "/admin/sign-in" do |env|
  page_title = "Sign In | Admin"

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
      env.flash[:error] = "Username or password was incorrect!"
      env.redirect "/admin/sign-in"
    end

  else
    env.flash[:error] = "Username or password was incorrect!"
    env.redirect "/admin/sign-in"
  end
end

get "/admin/sign-out" do |env|
  Session.destroy_session(env, env.request.cookies["authentication_token"].value)
end
