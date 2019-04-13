require "kemal"
require "kilt/slang"
require "sass"
require "hardware"
require "json"
require "random/secure"
require "crypto/bcrypt/password"
require "colorize"

require "mcping"

module Hub
  VERSION = "0.1.0"
  STYLESHEET = Sass.compile_file "./src/views/application.sass"
end

require "granite/adapter/sqlite"
Granite::Adapters << Granite::Adapter::Sqlite.new({name: "sqlite", url: "sqlite3:./db/database.db"})
require "./lib/models/*"


require "./lib/config/*"
require "./lib/dns/*"

require "./lib/monitor"
require "./lib/monitoring"

require "./lib/flash"
require "./lib/background_task"

require "./lib/admin/*"
require "./lib/controllers/*"

require "./lib/background_tasks/*"

Kemal.run
