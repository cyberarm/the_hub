class Model
  class User < Granite::Base
    connection sqlite
    table users

    has_many :sessions
    has_many :api_keys

    column id : Int64, primary: true
    column username : String
    column email : String
    column password : String

    column role : Int32

    column last_login_at : Time = Time.utc
    column last_login_ip : String = ""

    validate_not_blank :username
    validate_not_blank :email
    validate_not_blank :password
    validate_not_blank :role

    validate_uniqueness :username
    validate_uniqueness :email

    validate_min_length :username, 4
    validate_min_length :email, 5 # A@B.C
    validate_min_length :password, 6

    timestamps

    ROLE_ADMIN = 512
    ROLE_MOD   =   1
    ROLE_USER  =   0

    def role_name : String
      case self.role
      when ROLE_ADMIN
        return "Administrator"
      when ROLE_MOD
        return "Moderator"
      when ROLE_USER
        return "User"
      else
        return "? UNKNOWN ?"
      end
    end
  end
end
