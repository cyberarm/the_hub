require "kemal"
require "kilt/slang"
require "sass"
require "hardware"
require "json"
require "random/secure"
require "crypto/bcrypt/password"

require "mcping"

module Hub
  VERSION = "0.1.0"
end

require "./lib/config/*"

require "./lib/*"

Kemal.run