h1.title Create API Key
.monitors
  .monitor
    .monitor_label
    .monitor_content
      form method="post" url="/admin/api_keys/new"
        label for="application_name" Application Name
        br
        input type="text" id="application_name" name="application_name" placeholder="Name of Application" required="true"
        br
        br
        input.button type="submit" value="Create"
