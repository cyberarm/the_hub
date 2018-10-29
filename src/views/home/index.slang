h1.title Overview
.monitors
  .overview
    h2 Systems
    .list
      - monitors.system_monitors.each do |monitor|
        - if monitor.up
          p.up #{monitor.name}
          p CPU: #{monitor.cpu.usage.to_i}%
          p RAM: #{monitor.memory.percent.round}%
          p #{(monitor.memory.used/1000.0/1000.0).round(1)}GiB / #{(monitor.memory.total/1000.0/1000.0).round(1)}GiB
          p DOWN: #{monitor.formatted_net_download}
          p UP: #{monitor.formatted_net_upload}
        - else
          p.down #{monitor.name}
    - unless monitors.system_monitors.size > 0
      p No Monitors

  .overview
    h2 Web Servers
    .list
      - monitors.web_server_monitors.each do |monitor|
        - if monitor.up
          p.up #{monitor.name}
        - else
          p.down #{monitor.name}
    - unless monitors.web_server_monitors.size > 0
      p No Monitors

  .overview
    h2 Game Servers
    .list
      - monitors.game_server_monitors.each do |monitor|
        - if monitor.up
          p.up #{monitor.name}
        - else
          p.down #{monitor.name}
    - unless monitors.game_server_monitors.size > 0
      p No Monitors

  .overview
    h2 Sensors/IoT
    .list
      - monitors.sensor_iot_monitors.each do |monitor|
        - if monitor.up
          p.up #{monitor.name}
        - else
          p.down #{monitor.name}
    - unless monitors.sensor_iot_monitors.size > 0
      p No Monitors