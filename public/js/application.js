class Application {
  constructor() {
    this.self = this; // This feels REALLY weird
    self.xmlHttpRequest = null;
  }

  run(app) {
    self = app;
    setInterval(self.update, 1000);
    self.xhr();
  }

  /*
    currently does nothing
  */
  stop() {
    stopInterval();
  }

  update() {
    if (self.xhr_ready()) {
      self.xhr();
    }
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
      document.getElementsByClassName("container")[0].innerHTML = self.xmlHttpRequest.response;
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

app = new Application();
app.run(app);