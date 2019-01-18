h1.title New Monitor
.monitors
  .monitor
    .monitor_label
    .monitor_content
      form method="post" url="/admin/monitors/new"
        label for="name" Name
        br
        input type="text" id="name" name="name" placeholder="Example.org" required="true"
        br
        br
        label for="type" Type
        br
        select id="type" name="type" required="true"
          - Monitoring.monitor_types.each do |key, value|
              option value="#{key}" #{value}
        br
        br
        label for="update_interval" Update Interval (seconds)
        br
        input type="text" id="update_interval" name="update_interval" placeholder="1.0" required="true"
        br
        br
        label for="domain" Domain
        br
        input type="text" id="domain" name="domain" placeholder="hostname:8008"
        br
        br
        label for="game" Game
        br
        select id="game" name="game"
          option value="" selected="true" disabled="true" hidden="true"
          - Monitoring.monitor_game_types.each do |key, value|
              option value="#{key}" #{value}
        br
        br
        input.button type="submit" value="Add"
