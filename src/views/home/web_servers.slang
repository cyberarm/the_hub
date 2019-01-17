h1.title Web Servers
.monitors
  - monitors.each do |monitor|
    .monitor
      .monitor_label
        - if monitor.up
          h1.up #{monitor.name}
        - else
          h1.down #{monitor.name}
      .monitor_content
        - if monitor.up
          p Uptime #{monitor.formatted_uptime}
          p Ping #{monitor.ping}ms
        - else
          p Downtime #{monitor.formatted_downtime}
          p Last error #{monitor.last_error}

