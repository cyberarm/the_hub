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

    session = Model::Session.find_by(token: cookie)
    if session && session.token.not_nil!
      if session.token.not_nil! == cookie
        valid = true
      end
    end

    return valid
  end

  def create_session(env, user_id : Int64, user_ip : String) : Bool
    random = Random.new
    key = random.urlsafe_base64(32)
    session = Model::Session.create(user_id: user_id, token: key, user_ip: user_ip)

    if session && session.token.not_nil!
      cookie = HTTP::Cookie.new("authentication_token", key)
      cookie.http_only = true
      env.response.cookies["authentication_token"] = cookie
      env.redirect "/"
      return true
    else
      return false
    end
  end

  def destroy_session(cookie) : Bool
    valid = false

    session = Model::Session.find_by(token: cookie)
    if session && session.token.not_nil!
      if session.token.not_nil! == cookie
        session.destroy

        valid = true unless session
      end
    end

    return valid
  end
end