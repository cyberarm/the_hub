html
  head
    title #{page_title} | The Hub
    link rel="stylesheet" href="/css/application.css"
    script src="/js/application.js"

  body
    h1.app_title The Hub
    .header
      .nav_button
        p
          a href="/" Overview
      .nav_button
        p
          a href="/systems" Systems
      .nav_button
        p
          a href="/web-servers" Web Servers
      .nav_button
        p
          a href="/game-servers" Game Servers
      .nav_button
        p
          a href="/sensors" Sensors/IoT
      - if authenticated?(env) && admin?(env)
        .nav_button class="admin"
          p
            a href="/admin" Admin
        .nav_button class="admin"
          p
            a href="/admin/sign-out" Sign Out
      - else
        .nav_button class="admin"
          p
            a href="/admin/sign-in" Sign In
    .container
      == content