require 'heroku-api'
require 'locomotive/heroku/patches'
require 'locomotive/heroku/custom_domain'
require 'locomotive/heroku/first_installation'
require 'locomotive/heroku/enabler'

module Locomotive
  module Heroku

    class << self
      attr_accessor :connection, :app_name, :domains

      def domains
        if @domains.nil?
          response = self.connection.get_domains(self.app_name)

          if response.status == 200
            @domains = response.body.map { |h| h['domain'] }.reject { |n| n.starts_with?('*') }
          else
            @domains = []
          end
        else
          @domains
        end
      end

      def connection
        return @connection if @connection

        raise 'The Heroku API key is mandatory' if ENV['HEROKU_API_KEY'].blank? && Locomotive.config.hosting[:api_key].blank?

        @connection = ::Heroku::API.new(:api_key => ENV['HEROKU_API_KEY'] || Locomotive.config.hosting[:api_key])
      end

      def app_name
        return @app_name if @app_name

        raise 'The Heroku application name is mandatory' if ENV['APP_NAME'].blank? && Locomotive.config.hosting[:app_name].blank?

        @app_name = Locomotive.config.hosting[:app_name] || ENV['APP_NAME']
      end
    end

    def self.add_domain(name)
      Locomotive.log "[add heroku domain] #{name}"

      response = self.connection.post_domain(self.app_name, name)

      if response.status >= 200 && response.status < 300
        self.domains << name
      end
    end

    def self.remove_domain(name)
      Locomotive.log "[remove heroku domain] #{name}"
      self.connection.delete_domain(self.app_name, name)
      self.domains.delete(name)
    end

  end
end