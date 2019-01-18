h1.title #{monitor.name}
.monitors
  .monitor
    .monitor_label
    .monitor_content style="text-align: left"
      - m = get_monitor(monitor.id)
      - if m
        - m.to_hash.each do |key, value|
          p #{key}: #{value}
      p
        a href="/admin/monitors/#{monitor.id}/edit" Edit
        |/
        span.admin
          a href="/admin/monitors/#{monitor.id}/delete" onclick="return confirm('Are you sure?');" Delete