class Session
  def self.valid_session?(cookie : String, update_session = false) : Bool
    valid = false

    session = Model::Session.find_by(token: cookie)
    if session && session.token.not_nil!
      if session.token.not_nil! == cookie
        session.update(updated_at: Time.utc) if update_session
        valid = true
      end
    end

    return valid
  end

  def self.create_session(env, user_id : Int64, user_ip : String) : Bool
    random = Random.new
    key = random.urlsafe_base64(32)
    session = Model::Session.create(user_id: user_id, token: key, user_ip: user_ip)

    if session && session.token.not_nil!
      expires_at = Time.utc + FriendlyConfig::EXPIRE_SESSION_AFTER
      cookie = HTTP::Cookie.new("authentication_token", key)
      cookie.expires = expires_at
      cookie.http_only = true
      env.response.cookies["authentication_token"] = cookie

      env.flash[:notice] = "Signed in successfully"
      env.redirect "/"

      return true
    else
      env.flash[:error] = "Failed to create session, try again."
      env.redirect "/admin/sign-in"

      return false
    end
  end

  def self.destroy_session(env, cookie : String)
    session = Model::Session.find_by(token: cookie)
    valid = false

    if session && session.token.not_nil!
      if session.token.not_nil! == cookie
        if session.destroy
          valid = true

          env.response.cookies["authentication_token"] = ""
          env.flash[:notice] = "Signed out successfully"
          env.redirect "/"
        end
      end
    end

    unless valid
      env.flash[:error] = "Failed to sign out, try again."
      env.redirect "/admin/sign-in"
    end
  end
end
