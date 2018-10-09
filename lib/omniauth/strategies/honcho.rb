require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class Honcho < OmniAuth::Strategies::OAuth2
      # change the class name and the :name option to match your application name
      option :name, "honcho"

      option :client_options, {
        :site => "http://honcho.test",
        :authorize_url => "/oauth/authorize"
      }

      uid { raw_info["id"] }

      info do
        {
          name:  raw_info["full_name"],
          email: raw_info["email"],
          first_name: raw_info["first_name"],
          last_name: raw_info["last_name"],
          image: raw_info["avatar_url"]
        }
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v1/me.json').parsed
      end

      # https://github.com/intridea/omniauth-oauth2/issues/81
      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end
