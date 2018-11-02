class Session
  @@singleton = new.as(self)
  def self.instance : Session
    @@singleton
  end

  @sessions = [] of String
  def initialize
  end

  def valid_session?(cookie : String) : Bool
    valid = false

    @sessions.each do |session|
      if session == cookie
        valid = true
        break
      end
    end

    return valid
  end

  def create_session : String
    random = Random.new
    key = random.urlsafe_base64(32)
    @sessions.push(key)

    return key
  end

  def destroy_session(cookie) : Bool
    valid = false

    @sessions.each do |session|
      if session == cookie
        valid = true
        @sessions.delete(session)
        break
      end
    end

    return valid
  end
end