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
      ul
        li.up example.com
        li.down example.org
        li.up example.net

  .overview
    h2 Game Servers
    .list
      ul
        li.up Minetest
        li.up Minecraft
        li.down Command & Conquer: Renegade

  .overview
    h2 Sensors/IoT
    .list
      ul
        li.up Livingroom Temperature and Humidity Sensor