puts "\t...loading heroku extension"

# require 'locomotive/config'
require 'heroku-api'
require 'locomotive/heroku/patches'
# require 'locomotive/heroku/custom_domain'
# require 'locomotive/heroku/first_installation'

module Locomotive
  module Heroku

    class << self
      attr_accessor :connection, :app_name, :domains

      def domains
        if @domains.nil?
          @domains = self.connection.get_domains(self.app_name)
        else
          @domains
        end
      end

      def connection
        return @connection if @connection

        raise 'The Heroku API key is mandatory' if ENV['HEROKU_API_KEY'].blank? && Locomotive.config.heroku[:api_key].blank?

        @connection = ::Heroku::API.new(:api_key => ENV['HEROKU_API_KEY'] || Locomotive.config.heroku[:api_key], :mock => ENV['MOCK_HEROKU'].present?)
      end

      def app_name
        return @app_name if @app_name

        raise 'The Heroku application name is mandatory' if ENV['APP_NAME'].blank? && Locomotive.config.heroku[:app_name].blank?

        @app_name = Locomotive.config.heroku[:app_name] ||  ENV['APP_NAME']
      end
    end

    def self.add_domain(name)
      Locomotive.log "[add heroku domain] #{name}"
      self.connection.post_domains(self.app_name, name)
      self.domains << name
    end

    def self.remove_domain(name)
      Locomotive.log "[remove heroku domain] #{name}"
      self.connection.delete_domain(self.app_name, name)
      self.domains.delete(name)
    end

    def self.enable
      Locomotive.config.domain = 'heroku.com' unless Locomotive.config.multi_sites?

      # rack_cache: disabled because of Varnish
      Locomotive.config.rack_cache = false

      # hooks
      Locomotive::Site.send :include, Locomotive::Heroku::CustomDomain
      Locomotive::Site.send :include, Locomotive::Heroku::FirstInstallation

      # initialize the API connection
      self.connection
    end

  end
end