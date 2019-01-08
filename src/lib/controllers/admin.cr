def get_monitor(model_id)
  Monitoring.instance.monitors.find { |m| m.model_id == model_id }
end

get "/admin" do |env|
  page_title = "Admin"
  monitors = Model::Monitor.all
  accounts = Model::User.all
  render "./src/views/admin/index.slang", "./src/views/admin/admin_layout.slang"
end

get "/admin/accounts" do |env|
  page_title = "Accounts | Admin"
  accounts = Model::User.all
  render "./src/views/admin/accounts/index.slang", "./src/views/admin/admin_layout.slang"
end

def bcrypt_password(password)
  Crypto::Bcrypt::Password.create(password)
end

def check_password(password_hash : String | Nil, password_from_form : String)
  if Crypto::Bcrypt::Password.new(password_hash) == password_from_form
    return true
  else
    return false
  end
end

require "./admin/*"
