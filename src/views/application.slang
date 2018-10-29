html
  head
    title The Hub
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
    .container
      == content