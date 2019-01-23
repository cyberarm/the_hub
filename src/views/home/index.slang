h1.title Overview
.monitors
  .overview
    h2 Systems
    .list
      - if monitors.system_monitors.size > 0
        - monitors.system_monitors.each do |monitor|
          - if monitor.up
            p.up
              span class="status_left" #{monitor.name}
              span class="status_right" #{monitor.mini_status}
            p CPU: #{monitor.cpu.usage.to_i}%
            p RAM: #{monitor.memory.percent.round}%
            p #{(monitor.memory.used/1000.0/1000.0).round(1)}GiB / #{(monitor.memory.total/1000.0/1000.0).round(1)}GiB
            p DOWN: #{monitor.formatted_net_download}
            p UP: #{monitor.formatted_net_upload}
          - else
            p.down
              span class="status_left" #{monitor.name}
              span class="status_right" #{monitor.mini_status}
      - else
        p No Monitors

  .overview
    h2 Web Servers
    .list
      - if monitors.web_server_monitors.size > 0
        - monitors.web_server_monitors.each do |monitor|
          - if monitor.up
            p.up
              span class="status_left" #{monitor.name}
              span class="status_right" #{monitor.mini_status}
          - else
            p.down
              span class="status_left" #{monitor.name}
              span class="status_right" #{monitor.mini_status}
      - else
        p No Monitors

  .overview
    h2 Game Servers
    .list
      - if monitors.game_server_monitors.size > 0
        - monitors.game_server_monitors.each do |monitor|
          - if monitor.up
            p.up
              span class="status_left" #{monitor.name}
              span class="status_right" #{monitor.mini_status}
          - else
            p.down
              span class="status_left" #{monitor.name}
              span class="status_right" #{monitor.mini_status}
      - else
        p No Monitors

  .overview
    h2 Sensors/IoT
    .list
      - if monitors.sensor_iot_monitors.size > 0
        - monitors.sensor_iot_monitors.each do |monitor|
          - if monitor.up
            p.up
              span class="status_left" #{monitor.name}
              span class="status_right" #{monitor.mini_status}
          - else
            p.down
              span class="status_left" #{monitor.name}
              span class="status_right" #{monitor.mini_status}
      - else
        p No Monitors