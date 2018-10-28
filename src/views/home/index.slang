h1.title Overview
.monitors
  .monitor
    .monitor_content
      data data-monitor="cpu_monitor" data-type="arc_progressbar"
        p #{cpu.usage.to_i}%
    .monitor_label
      p CPU Monitor

  .monitor
    .monitor_content
      data data-monitor="cpu_monitor" data-type="arc_progressbar"
        p #{memory.percent.to_i}%
    .monitor_label
      p RAM Monitor

  .monitor
    .monitor_content
      data data-monitor="network_download" data-type="network"
        p 0%
    .monitor_label
      p Network Upload Monitor

  .monitor
    .monitor_content
      data data-monitor="network_upload" data-type="network"
        p 0%
    .monitor_label
      p Network Download Monitor

.monitors
  .overview
    h2 Web Servers
    .list
      - has_web_monitor = false
      ul
        - if monitors != nil
          - monitors.each do |monitor|
            - next unless monitor.is_a?(WebServerMonitor)
            - has_web_monitor = true
            - if monitor.up
              li.up #{monitor.name}
            - else
              li.down #{monitor.name}
      - unless has_web_monitor
        p No Monitors

  .overview
    h2 Game Servers
    .list
      - has_game_monitor = false
      ul
        - if monitors != nil
          - monitors.each do |monitor|
            - next unless monitor.is_a?(GameServerMonitor)
            - has_game_monitor = true
            - if monitor.up
              li.up #{monitor.name}
            - else
              li.down #{monitor.name}
      - unless has_game_monitor
        p No Monitors

  .overview
    h2 Sensors/IoT
    .list
      ul
        - if monitors != nil
          - monitors.each do |monitor|
            - next unless monitor.is_a?(SensorIoTMonitor)
            - has_game_monitor = true
            - if monitor.up
              li.up #{monitor.name}
            - else
              li.down #{monitor.name}
      - unless has_game_monitor
        p No Monitors