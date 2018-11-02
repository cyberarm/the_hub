h1.title All Monitors
.monitors
  - monitoring.monitors.each_with_index do |monitor, i|
    .monitor
      .monitor_label
        - if monitor.up
          h2.up #{monitor.name}
        - else
          h2.down #{monitor.name}
      .monitor_content
        p Type: #{monitor.class}
        p
          a href="/admin/monitors/#{i}" Details
          |/
          a href="/admin/monitors/#{i}" Edit
          |/
          span.admin
            a href="/admin/monitors/#{i}/destroy" Delete