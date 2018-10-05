require "omniauth/honcho/version"
require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class Honcho < OmniAuth::Strategies::OAuth2
      # change the class name and the :name option to match your application name
      option :name, "honcho"

      option :client_options, {
        :site => "http://knowyourcompany.com",
        :authorize_url => "/oauth/authorize"
      }

      uid { raw_info["id"] }

      info do
        {
          id: raw_info["id"],
          email: raw_info["email"],
          full_name: raw_info["full_name"],
          avatar_url: raw_info["avatar_url"]
        }
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