class FriendlyConfig
  @username : String
  @email : String
  @password : String

  def initialize
    @username = ""
    @email = ""
    @password = ""
  end

  def run
    unless File.exists?("./data/database.db")
      create_database
      start_config
    else
      verify_admin_account
    end
  end

  def verify_admin_account
    begin
      admins = Model::User.find_by(role: Model::User::ROLE_ADMIN)
    rescue SQLite3::Exception
    end

    unless admins
      create_database
      start_config
    end
  end

  def create_database
    Model::User.migrator.drop_and_create
    Model::Session.migrator.drop_and_create
    Model::Monitor.migrator.drop_and_create
    Model::ApiKey.migrator.drop_and_create
  end

  def start_config
    puts "Configure The Hub"
    if @username == ""
      username = ask("Username", 4)
      @username = username.downcase
      puts "Hello, #{@username}"
    end

    if @email == ""
      email = ask("Email", 5)
      @email = email.downcase
      puts "Got, #{@email}."
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
      start_config
    end
  end

  def save_config
    Model::User.create(username: @username, email: @email, password: @password, role: Model::User::ROLE_ADMIN)
  end

  def create_bcrypt_password(string)
    puts "Processing password...".colorize(:yellow)
    @password = Crypto::Bcrypt::Password.create(string).to_s
    puts "Success!".colorize(:green).mode(:bold)
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
end

FriendlyConfig.new.run
