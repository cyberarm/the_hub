class FriendlyConfig
  @@config : Config?

  @username : String
  @password : String
  def initialize
    @username = ""
    @password = ""
  end

  def run
    unless File.exists?("./data/config.json")
      start_config
    else
      verify_config
    end
  end

  def start_config(retry = false)
    start = "y" if retry
    puts " Hub not configured, start configurator? [#{"Yes".colorize(:yellow).mode(:bold)}|#{"No".colorize(:red).mode(:bold)}]" unless retry
    start = ask("Start?", 1) unless retry
    if start.not_nil!.downcase.includes?("y")
      if @username == ""
        username = ask("Username", 4)
        @username= username.downcase
        puts "Hello, #{@username}"
      end
      pass = password("Password")
      puts
      confirmation = password("Confirm")
      puts

      if pass == confirmation
        create_bcrypt_password(pass)
        save_config
      else
        puts
        puts "Error: Passwords did not match, try again...".colorize(:red).mode(:bold)
        puts
        start_config(true)
      end

    else start.not_nil!.downcase.includes?("n")
      puts "See you later then, bye."
      exit
    end
  end

  def save_config
    File.open("./data/config.json", "w") do |file|
      file.write({
        admin: {
          username: @username,
          password: @password
        }
      }.to_json.to_slice)
    end
  end

  def create_bcrypt_password(string)
    puts "Processing password...".colorize(:yellow)
    @password = Crypto::Bcrypt::Password.create(string).to_s
    puts "Success!".colorize(:green).mode(:bold)
  end

  def verify_config
    config = FriendlyConfig.config.not_nil!
    unless config.admin["username"]? && config.admin["password"]?
      start_config
    end
  end

  def ask(label : String, min_length = 0)
    print "#{label.colorize(:green)}[#{min_length} required chars]>"
    input = gets.not_nil!.chomp

    unless input.size >= min_length
      puts "Try again"
      ask(label, min_length)
    end

    return input
  end

  def password(label, min_length = 6)
    print "#{label.colorize(:red)}[#{min_length} required chars]>"
    input = STDIN.noecho do
      gets.not_nil!.chomp
    end

    unless input.size >= min_length
      puts "Try again"
      password(label, min_length)
    end

    return input
  end

  def self.config
    @@config ||= Config.from_json(File.open("./data/config.json"))
    return @@config
  end
end

FriendlyConfig.new.run