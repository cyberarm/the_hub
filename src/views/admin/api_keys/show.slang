h1.title #{api_key.application_name}
.monitors
  .monitor
    .monitor_label
    .monitor_content style="text-align: left"
      p Last access IP: #{api_key.last_access_ip}
      p Last used at: #{api_key.updated_at.not_nil!.to_s("%Y-%m-%d %H:%M:%S %:z")}
      br
      p Token:
        span class="sensitive" #{api_key.token}
      br
      p
        a href="/admin/api_keys/#{api_key.id}/edit" Edit
        |/
        span.admin
          a href="/admin/api_keys/#{api_key.id}/delete" onclick="return confirm('Are you sure?');" Delete