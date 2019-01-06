h1.title class="admin" Administration
.monitors
  .monitor
    .monitor_label
      h2
        a href="/admin/monitors" Monitors
    .monitor_content
      - monitoring.monitors.each_with_index do |monitor, i|
        -if monitor.up
          p.up
            a href="/admin/monitors/#{i}" #{monitor.name}
        - else
          p.down
            a href="/admin/monitors/#{i}" #{monitor.name}
  .monitor
    .monitor_label
      h2
        a href="/admin/accounts" Accounts
    .monitor_content
      - if accounts
        - accounts.each do |account|
          p
            a href="/admin/accounts/#{account.username}" =account.username