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
end

require "granite/adapter/sqlite"
Granite::Adapters << Granite::Adapter::Sqlite.new({name: "sqlite", url: "sqlite3:./data/database.db"})
require "./lib/monitor"
require "./lib/monitoring"

require "./lib/models/*"

require "./lib/config/*"
require "./lib/admin/*"
require "./lib/controllers/*"

Kemal.run
