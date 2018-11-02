h1.title #{monitor.name}
.monitors
  .monitor
    .monitor_label
    .monitor_content style="text-align: left"
      - JSON.parse(monitor.to_json).as_h.each do |key, value|
        p #{key}: #{value}