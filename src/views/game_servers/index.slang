h1.title Game Servers
.monitors
  - monitors.each do |monitor|
    .monitor
      .monitor_label
        - if monitor.up
          h1.up.monitor_status_link
            a href="/game-servers/#{monitor.model_id}" #{monitor.name}
        - else
          h1.down.monitor_status_link
            a href="/game-servers/#{monitor.model_id}"#{monitor.name}
      .monitor_content
        p
          == monitor.report
  - unless monitors.size > 0
    h2.title No Monitors