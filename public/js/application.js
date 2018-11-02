class Application {
  constructor() {
    this.self = this; // This feels REALLY weird, and kinda familiar
    self.xmlHttpRequest = null;
  }

  run(app) {
    self = app;
    setInterval(self.update, 1000);
  }

  /*
    currently does nothing
  */
  stop() {
    stopInterval();
  }

  update() {
    if (!self.admin_page() && self.xhr_ready()) {
      self.xhr();
    }
  }

  admin_page() {
    return window.location.href.includes("/admin");
  }

  xhr() {
    self.xmlHttpRequest = new XMLHttpRequest();
    self.xmlHttpRequest.responseType = "text";
    self.xmlHttpRequest.open("GET", window.location.href);
    self.xmlHttpRequest.setRequestHeader("X-XHR", "xmlhttprequest");

    self.xmlHttpRequest.onerror = function(error) {
      self.xmlHttpRequest = null; // Failed, allow update() to retry
    }
    self.xmlHttpRequest.onload = function() {
      if (self.xmlHttpRequest.responseURL === window.location.href) {
        document.getElementsByClassName("container")[0].innerHTML = self.xmlHttpRequest.response;
      } else {
        console.log("Server redirected request to '"+ self.xmlHttpRequest.responseURL +"' from '"+ window.location.href +"'");
        window.location = self.xmlHttpRequest.responseURL;
      }
    }

    self.xmlHttpRequest.send();
  }

  xhr_ready() {
    try {
      return self.xmlHttpRequest.status === 200;
    } catch (ReferenceError) {
      return true;
    }
  }
}

window.onload = function() {
  console.log("Window Loaded")
  app = new Application();
  app.run(app);
}