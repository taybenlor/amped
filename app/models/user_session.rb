class UserSession < Authlogic::Session::Base
  find_by_login_method :find_by_email
end