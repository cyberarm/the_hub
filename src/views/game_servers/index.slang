h1.title Game Servers
.monitors
  - monitors.each do |monitor|
    .monitor
      .monitor_label
        - if monitor.up
          h1.up
            a href="/game-servers/#{monitor.model_id}" #{monitor.name}
        - else
          h1.down
            a href="/game-servers/#{monitor.model_id}"#{monitor.name}
      .monitor_content
        p
          == monitor.report