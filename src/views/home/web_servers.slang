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
          p Uptime #{monitor.uptime.days}d #{monitor.uptime.hours}h #{monitor.uptime.minutes}m #{monitor.uptime.seconds}s
        - else
          p Downtime #{monitor.downtime.days}d #{monitor.downtime.hours}h #{monitor.downtime.minutes}m #{monitor.downtime.seconds}s
          p Last error #{monitor.last_error}

