h1.title class="admin" Administration
.monitors
  .monitor
    .monitor_label
      h2
        a href="/admin/monitors" Monitors
    .monitor_content
      - if monitors
        - monitors.each do |db_monitor|
          - monitor = get_monitor(db_monitor.id)
          - next unless monitor
          -if monitor.up
            p.up.monitor_status_link
              a href="/admin/monitors/#{db_monitor.id}" #{monitor.name}
          - else
            p.down.monitor_status_link
              a href="/admin/monitors/#{db_monitor.id}" #{monitor.name}
  .monitor
    .monitor_label
      h2
        a href="/admin/accounts" Accounts
    .monitor_content
      - if accounts
        - accounts.each do |account|
          p #{account.role_name} #{account.username}
  .monitor
    .monitor_label
      h2
        a href="/admin/api_keys" API Keys
    .monitor_content
      - if api_keys
        - api_keys.each do |api_key|
          p
            a href="/admin/api_keys/#{api_key.id}" #{api_key.application_name}