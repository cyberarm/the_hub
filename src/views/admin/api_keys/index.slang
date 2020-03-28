h1.title All API Keys
center
  p.button
    a href="/admin/api_keys/new" Create API Key
br

.monitors
  - if api_keys
    - user = current_user(env)
    - api_keys.each do |db_api_key|
      - if user
        - next unless user.id == db_api_key.user_id
      .monitor
        .monitor_label
          h2 #{db_api_key.application_name}
        .monitor_content
          p Last access IP: #{db_api_key.last_access_ip}
          p Last used at: #{db_api_key.updated_at.not_nil!.to_s("%Y-%m-%d %H:%M:%S %:z")}
          p
            a href="/admin/api_keys/#{db_api_key.id}" Details
            |/
            a href="/admin/api_keys/#{db_api_key.id}/edit" Edit
            |/
            span.admin
              a href="/admin/api_keys/#{db_api_key.id}/delete" onclick="return confirm('Are you sure?');" Delete