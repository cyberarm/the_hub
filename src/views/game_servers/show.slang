h1.title = db_monitor.name
.monitors
  .monitor
    - monitor = get_monitor(db_monitor.id).as(GameServerMonitor)
    - if
      .monitor_label
        - if monitor
          - if monitor.up
            h1.up #{monitor.name}
          - else
            h1.down #{monitor.name}
      .monitor_content
        p
          == monitor.full_report
        - if current_user(env) && admin?(env)
          p
            a href="/admin/monitors/#{db_monitor.id}/edit" Edit
            |/
            span.admin
              a href="/admin/monitors/#{db_monitor.id}/delete" onclick="return confirm('Are you sure?');" Delete
