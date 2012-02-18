module Locomotive
  module Heroku
    module CustomDomain

      extend ActiveSupport::Concern

      included do
        after_save    :sync_heroku_domains
        after_destroy :remove_heroku_domains
      end

      protected

      def sync_heroku_domains
        # all the Heroku domains should also referenced in the site, if not then remove them from Heroku.
        Locomotive::Heroku.domains.each do |domain|
          unless self.domains_without_subdomain.include?(domain)
            Locomotive::Heroku.remove_domain(domain)
          end
        end

        # add the site domains should referenced in the Heroku domains, if not then add them to Heroku
        self.domains_without_subdomain.each do |domain|
          unless Locomotive::Heroku.domains.include?(domain)
            Locomotive::Heroku.add_domain(domain)
          end
        end
      end

      def remove_heroku_domains
        self.domains_without_subdomain.each do |domain|
          Locomotive::Heroku.remove_domain(domain)
        end
      end

    end
  end
end