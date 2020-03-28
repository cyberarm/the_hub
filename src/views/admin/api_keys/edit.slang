h1.title Edit API Key
.monitors
  .monitor
    .monitor_label
    .monitor_content
      form method="post" url="/admin/api_keys/edit"
        label for="application_name" Application Name
        br
        input type="text" id="application_name" name="application_name" placeholder="Name of Application" required="true" value="#{api_key.not_nil!.application_name}"
        br
        br
        input.button type="submit" value="Update"
