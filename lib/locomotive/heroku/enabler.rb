module Locomotive

  def self.enable_heroku
    Locomotive.config.domain = 'herokuapp.com' unless Locomotive.config.multi_sites?

    # we can manage domains within Heroku no matter what the value of the multi_sites option is
    Locomotive.config.manage_domains    = true
    Locomotive.config.manage_subdomain  = false unless Locomotive.config.multi_sites?

    # rack_cache: disabled because of Varnish
    Locomotive.config.rack_cache = false

    # hooks
    Locomotive::Site.send :include, Locomotive::Heroku::CustomDomain
    Locomotive::Site.send :include, Locomotive::Heroku::FirstInstallation

    # initialize the API connection
    Locomotive::Heroku.connection

    # load all the domains
    Locomotive::Heroku.domains
  end

end