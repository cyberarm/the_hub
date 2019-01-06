h1.title New Monitor
.monitors
  .monitor
    .monitor_label
    .monitor_content
      form method="post" url="/admin/monitors/new"
        label for="name" Name
        br
        input type="text" id="name" name="name" placeholder="Example.org"
        br
        br
        label for="type" Type
        br
        select id="type" name="type"
          option value="web" Web Server
          option value="game" Game Server
          option value="sensor" Sensor or IOT
          option value="system" System
        br
        br
        label for="domain" Domain
        br
        input type="text" id="domain" name="domain" placeholder="hostname:8008"
        br
        br
        label for="update_interval" Update Interval (seconds)
        br
        input type="text" id="update_interval" name="update_interval" placeholder="1.0"
        br
        br
        label for="game" Game
        br
        select id="game" name="game"
          option value="minecraft" Minecraft
          option value="minetest" Minetest
          option value="cncrenegade" Command and Conquer: Renegade
        br
        br
        input type="submit" value="Add"
