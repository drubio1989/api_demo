class UserAuthenticator::Standard < UserAuthenticator
    class AuthenticationError < StandardError; end
    attr_reader :user

    def initialize(login, password)
      @login = login
      @password = password
    end

    def perform
      raise AuthenticationError if (login.blank? || password.blank?)
      raise AuthenticationError unless User.exists?(login: login)
      user = User.find_by(login: login)
      raise AuthenticationError unless user.password == password
      @user = user

      @access_token = if user.access_token.present?
        user.access_token
      else
        user.create_access_token
      end
    end

    private

    attr_reader :login, :password
  end
