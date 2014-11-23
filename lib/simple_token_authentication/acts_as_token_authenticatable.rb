require 'active_support/concern'
require 'simple_token_authentication/token_generator'

module SimpleTokenAuthentication
  module ActsAsTokenAuthenticatable
    extend ::ActiveSupport::Concern

    # Please see https://gist.github.com/josevalim/fb706b1e933ef01e4fb6
    # before editing this file, the discussion is very interesting.

    included do
      public :generate_authentication_token
      private :token_suitable?
      private :token_generator
    end

    def ensure_authentication_token
      # TODO: A timeout to remove tokens.
      # Tokens are no longer created here.
      # self.session_tokens.create!(authentication_token: generate_authentication_token(token_generator))
    end

    def generate_authentication_token(token_generator)
      loop do
        token = token_generator.generate_token
        break token if token_suitable?(token)
      end
    end

    def token_suitable?(token)
      # This makes sure there are no users who already have this exact same token.
      self.class.all.each do |user|
        user.session_tokens.each do |one_token|
          return false if one_token == token
        end
      end
      return true
    end

    def token_generator
      @token_generator ||= TokenGenerator.new
    end

    module ClassMethods
      def acts_as_token_authenticatable(options = {})
        # before_save :ensure_authentication_token
      end
    end
  end
end
