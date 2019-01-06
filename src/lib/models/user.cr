class Model
  class User < Granite::Base
    adapter sqlite

    field username : String
    field email : String
    field password : String

    field role : Int32

    field last_login_at : Time
    field last_login_ip : String

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

    def self.get_role_name(role : Int32) : String
      case role
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
