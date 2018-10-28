h1.title System
- monitors.each do |monitor|
  h2.title #{monitor.name}
  .monitors
    .monitor
      .monitor_label
        p CPU Monitor
      .monitor_content
        data data-monitor="cpu_monitor" data-type="arc_progressbar"
          h1 #{monitor.cpu.usage.to_i}%

    .monitor
      .monitor_label
        p RAM Monitor
      .monitor_content
        data data-monitor="memory_monitor" data-type="arc_progressbar"
          h1 #{monitor.memory.percent.to_i}%
          p #{(monitor.memory.used/1000.0/1000.0).round(1)}GiB used / #{(monitor.memory.total/1000.0/1000.0).round(1)}GiB total

    .monitor
      .monitor_label
        p Network Upload Monitor
      .monitor_content
        data data-monitor="network_download" data-type="network"
          - if monitor.net_download > 1000
            h1 #{(monitor.net_download / 1000).round(2)}MB/s
          - else
            h1 #{monitor.net_download}kB/s

    .monitor
      .monitor_label
        p Network Download Monitor
      .monitor_content
        data data-monitor="network_upload" data-type="network"
          - if monitor.net_upload > 1000
            h1 #{(monitor.net_upload / 1000).round(2)}MB/s
          - else
            h1 #{monitor.net_upload}kB/s