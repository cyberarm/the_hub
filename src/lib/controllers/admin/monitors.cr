get "/admin/monitors" do |env|
  page_title = "Monitors | Admin"
  errors = [] of String
  monitors = Model::Monitor.all
  render "./src/views/admin/monitors/index.slang", "./src/views/admin/admin_layout.slang"
end

get "/admin/monitors/new" do |env|
  page_title = "Add Monitor | Admin"
  monitoring = Monitoring.instance

  render "./src/views/admin/monitors/new.slang", "./src/views/admin/admin_layout.slang"
end
post "/admin/monitors/new" do |env|
  name = env.params.body["name"]?.to_s
  type = env.params.body["type"]?.to_s
  domain = env.params.body["domain"]?.to_s
  update_interval = env.params.body["update_interval"]?.to_s.to_f
  game = env.params.body["game"]?.to_s

  key = nil
  game = nil unless type == "game"

  if type == "sensor"
    random = Random.new
    key = random.urlsafe_base64(32)
  end

  m = Model::Monitor.create(name: name, type: type, domain: domain, update_interval: update_interval, game: game, key: key)
  if m && m.id != nil
    Monitoring.instance.add_monitor(m)

    env.flash[:notice] = "Monitor was successfully created"
    env.redirect "/admin/monitors/#{m.id}"
  else
    env.flash[:error] = "#{m.errors.map { |e| e.to_s }.join("<br/>")}"

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
post "/admin/monitors/:monitor/edit" do |env|
  monitor = Model::Monitor.find(env.params.url["monitor"].to_i)

  if monitor
    name = env.params.body["name"]?.to_s
    type = env.params.body["type"]?.to_s
    domain = env.params.body["domain"]?.to_s
    update_interval = env.params.body["update_interval"]?.to_s.to_f
    game = env.params.body["game"]?.to_s

    key = nil
    game = nil unless type == "game"

    if monitor.update(name: name, type: type, domain: domain, update_interval: update_interval, game: game, key: key)
      Monitoring.instance.sync_monitor(monitor)

      env.flash[:notice] = "monitor was successfully updated"
      env.redirect "/admin/monitors/#{monitor.id}"
    else
      env.flash[:error] = "#{monitor.errors.map { |e| e.to_s }.join("<br/>")}"
      env.redirect "/admin/monitors/#{monitor.id}/edit"
    end
  else
    halt(env, status_code: 404)
  end
end

get "/admin/monitors/:monitor/delete" do |env|
  monitor = Model::Monitor.find(env.params.url["monitor"].to_i)
  if monitor
    if monitor.destroy
      Monitoring.instance.delete_monitor(monitor.id)

      env.flash[:notice] = "Monitor was successfully destroyed"
      env.redirect "/admin/monitors"
    else
      env.flash[:error] = "Failed to destroy monitor!"
      env.redirect "/admin/monitors/#{monitor.id}"
    end
  else
    halt(env, status_code: 404)
  end
end
