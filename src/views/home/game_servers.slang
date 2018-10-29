h1.title Game Servers
.monitors
  - monitors.each do |monitor|
    .monitor
      .monitor_label
        - if monitor.up
          h1.up #{monitor.name}
        - else
          h1.down #{monitor.name}
      .monitor_content
        p
          == monitor.report