get "/admin" do |env|
end

get "/admin/sign-in" do
  render "./src/views/admin/sign_in.slang", "./src/views/application.slang"
end

post "/admin/sign-in" do |env|
  username = env.params.body["username"].as(String)
  password_from_form = env.params.body["password"].as(String)

  if username.downcase == FriendlyConfig.config.not_nil!.admin["username"].downcase
    if check_password(FriendlyConfig.config.not_nil!.admin["password"], password_from_form)
      env.response.cookies["authentication_token"] = "yes"
      env.redirect "/"
    else
      env.redirect "/admin/sign-in"
    end
  else
    env.redirect "/admin/sign-in"
  end
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