get "/admin/monitors" do |env|
  page_title = "Monitors | Admin"
  errors = [] of String
  monitors = Model::Monitor.all
  render "./src/views/admin/monitors/index.slang", "./src/views/admin/admin_layout.slang"
end

get "/admin/monitors/new" do |env|
  page_title = "Add Monitor | Admin"
  monitoring = Monitoring.instance

  hub_message = nil
  if env.request.cookies["hub_message"]? && env.request.cookies["hub_message"].value.size > 0
    hub_message = env.request.cookies["hub_message"].value
    env.response.cookies["hub_message"] = ""
  end

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
    if env.request.cookies["hub_message"]? && env.request.cookies["hub_message"].value.size > 0
      hub_message = env.request.cookies["hub_message"].value
      env.response.cookies["hub_message"] = ""
    end
    env.redirect "/admin/monitors/#{m.id}"
  else
    cookie = HTTP::Cookie.new("hub_message", "#{m.errors.map { |e| e.to_s }.join("<br/>")}")
    cookie.http_only = true
    env.response.cookies["hub_message"] = cookie
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
    hub_message = nil
    if env.request.cookies["hub_message"]? && env.request.cookies["hub_message"].value.size > 0
      hub_message = env.request.cookies["hub_message"].value
      env.response.cookies["hub_message"] = ""
    end

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
      env.redirect "/admin/monitors/#{monitor.id}"

    else
      cookie = HTTP::Cookie.new("hub_message", "#{monitor.errors.map { |e| e.to_s }.join("<br/>")}")
      cookie.http_only = true
      env.response.cookies["hub_message"] = cookie
      env.redirect "/admin/monitors/new"
    end

  else
    env.redirect "/admin/monitors"
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