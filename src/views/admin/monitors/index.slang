h1.title All Monitors
center
  p.button
    a href="/admin/monitors/new" Add Monitor
br

.monitors
  - if monitors
    - monitors.each do |db_monitor|
      - monitor = get_monitor(db_monitor.id)
      - next unless monitor
      .monitor
        .monitor_label
          - if monitor.up
            h2.up #{db_monitor.name}
          - else
            h2.down #{db_monitor.name}
        .monitor_content
          p Type: #{monitor.class}
          p
            a href="/admin/monitors/#{db_monitor.id}" Details
            |/
            a href="/admin/monitors/#{db_monitor.id}/edit" Edit
            |/
            span.admin
              a href="/admin/monitors/#{db_monitor.id}/delete" onclick="return confirm('Are you sure?');" Delete