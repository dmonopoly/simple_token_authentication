require 'devise'

module SimpleTokenAuthentication
  class TokenGenerator
    def generate_token
      # Generates a friendly string randomly to be used as token.
      Devise.friendly_token
    end
  end
end
