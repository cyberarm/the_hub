h1.title #{monitor.name}
.monitors
  .monitor
    .monitor_label
    .monitor_content style="text-align: left"
      - m = get_monitor(monitor.id)
      - if m
        - m.to_hash.each do |key, value|
          p #{key}: #{value}