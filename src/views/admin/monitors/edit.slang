h1.title=monitor.name
.monitors
  .monitor
    .monitor_label
    .monitor_content
      form method="post" url="/admin/monitors/#{monitor.id}/edit"
        label for="name" Name
        br
        input type="text" id="name" name="name" placeholder="Example.org" required="true" value="#{monitor.name}"
        br
        br
        label for="type" Type
        br
        select id="type" name="type" required="true"
          - Monitoring.monitor_types.each do |key, value|
            - if  monitor.type == key.to_s
              option value="#{key.to_s}" selected="true" #{value}
            - else
              option value="#{key.to_s}" #{value}
        br
        br
        label for="update_interval" Update Interval (seconds)
        br
        input type="number" min="1" step="0.01" id="update_interval" name="update_interval" placeholder="1.0" required="true"  value="#{monitor.update_interval}"
        br
        br
        label for="domain" Domain
        br
        input type="text" id="domain" name="domain" placeholder="hostname:8008" value="#{monitor.domain}"
        br
        br
        label for="game" Game
        br
        select id="game" name="game"
          option value="" selected="true" disabled="true" hidden="true"
          - Monitoring.monitor_game_types.each do |key, value|
            - if  monitor.game == key.to_s
              option value="#{key.to_s}" selected="true" #{value}
            - else
              option value="#{key.to_s}" #{value}
        br
        br
        label for="save_reports" Save Reports?
        - if monitor.save_reports
          input type="checkbox" id="save_reports" name="save_reports" checked="true"
        - else
          input type="checkbox" id="save_reports" name="save_reports"
        br
        br
        label for="max_reports" Max number of reports to store (0 for unlimited)
        br
        input type="number" id="max_reports" name="max_reports" placeholder="0" value="#{monitor.max_reports}" required="true" min="0"
        br
        br
        input.button type="submit" value="Update"
