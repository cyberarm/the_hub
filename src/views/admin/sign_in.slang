h1.title Sign In
.monitors
  .monitor
    .monitor_label
      h2 Sign In
    .monito_content
      - if hub_message
        p.error #{hub_message}
      form method="post" url="/admin/sign-in"
        label for="username" Username
        br
        input type="text" name="username" placeholder="admin" required="true" autofocus="true"
        br
        label for="password" Password
        br
        input type="password" name="password" placeholder="password" required="true"
        br
        br
        input type="submit" value="Sign In"