get "/admin/api_keys" do |env|
  page_title = "API Keys | Admin"
  errors = [] of String
  api_keys = Model::ApiKey.all
  render "./src/views/admin/api_keys/index.slang", "./src/views/admin/admin_layout.slang"
end

get "/admin/api_keys/new" do |env|
  page_title = "Create API Key | Admin"
  errors = [] of String
  render "./src/views/admin/api_keys/new.slang", "./src/views/admin/admin_layout.slang"
end
post "/admin/api_keys/new" do |env|
  application_name = env.params.body["application_name"]?.to_s

  user = current_user(env).not_nil!
  m = Model::ApiKey.create(application_name: application_name, user_id: user.id, token: Random::Secure.hex)
  if m && m.id != nil
    env.flash[:notice] = "API Key was successfully created"
    env.redirect "/admin/api_keys/#{m.id}"
  else
    env.flash[:error] = "#{m.errors.map { |e| e.to_s }.join("<br/>")}"

    env.redirect "/admin/api_keys/new"
  end
end

get "/admin/api_keys/:api_key" do |env|
  api_key = Model::ApiKey.find(env.params.url["api_key"].to_i64)

  if api_key
    page_title = "#{api_key.not_nil!.application_name} | API Keys | Admin"
    render "./src/views/admin/api_keys/show.slang", "./src/views/admin/admin_layout.slang"
  else
    halt(env, status_code: 404)
  end
end

get "/admin/api_keys/:api_key/edit" do |env|
  page_title = "Edit API Key | Admin"
  errors = [] of String
  api_key = Model::ApiKey.find(env.params.url["api_key"].to_i64)
  render "./src/views/admin/api_keys/edit.slang", "./src/views/admin/admin_layout.slang"
end
post "/admin/api_keys/:api_key/edit" do |env|
  api_key = Model::ApiKey.find(env.params.url["api_key"].to_i64)

  if api_key
    application_name = env.params.body["application_name"]?.to_s

    if api_key.update(application_name: application_name)

      env.flash[:notice] = "api_key was successfully updated"
      env.redirect "/admin/api_keys/#{api_key.id}"
    else
      env.flash[:error] = "#{api_key.errors.map { |e| e.to_s }.join("<br/>")}"
      env.redirect "/admin/api_keys/#{api_key.id}/edit"
    end
  else
    halt(env, status_code: 404)
  end
end

get "/admin/api_keys/:api_key/delete" do |env|
  api_key = Model::ApiKey.find(env.params.url["api_key"].to_i64)
  if api_key && api_key.not_nil!.user_id == current_user(env).not_nil!.id
    if api_key.destroy
      env.flash[:notice] = "API Key was successfully destroyed"
      env.redirect "/admin/api_keys"
    else
      env.flash[:error] = "Failed to destroy API key!"
      env.redirect "/admin/api_keys/#{api_key.id}"
    end
  else
    halt(env, status_code: 404)
  end
end