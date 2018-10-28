html
  head
    title The Hub
    link rel="stylesheet" href="/css/application.css"
    link
  body
    h1.app_title The Hub
    .header
      .nav_button
        p
          a href="/" Overview
      .nav_button
        p
          a href="/" System
      .nav_button
        p
          a href="/" Web Servers
      .nav_button
        p
          a href="/" Game Servers
      .nav_button
        p
          a href="/" Sensors/IoT
    .container
      == content