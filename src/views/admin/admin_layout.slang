html
  head
    title #{page_title} | The Hub
    link rel="stylesheet" href="/css/application.css"

  body
    h1.app_title class="admin" The Hub
    .header
      - if authenticated?(env)
        .nav_button class="admin"
          p
            a href="/admin/" Admin
        .nav_button class="admin"
          p
            a href="/admin/monitors" Monitors
        .nav_button class="admin"
          p
            a href="/admin/accounts" Accounts
        .nav_button
          p
            a href="/" Return to Hub
        .nav_button class="admin"
          p
            a href="/admin/sign-out" Sign Out
      - else
        .nav_button class="admin"
          p
            a href="/admin/sign-in" Sign In
    .container
      == content