require "kilt/slang"
require "sass"
require "hardware"
require "json"

module Hub
  VERSION = "0.1.0"
end

require "./lib/*"

Kemal.run