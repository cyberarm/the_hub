require "kemal"

get "/" do
  cpu    = Hardware::CPU.new
  memory = Hardware::Memory.new
  # net    = Hardware::Net.new
  render "./src/views/home/index.slang", "./src/views/application.slang"
end

get "/css/application.css" do
  Sass.compile_file "./src/views/application.sass"
end