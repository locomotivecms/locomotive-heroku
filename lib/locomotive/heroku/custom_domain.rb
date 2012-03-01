module Locomotive
  module Heroku
    module CustomDomain

      extend ActiveSupport::Concern

      included do
        before_save   :store_domains_to_remove_from_heroku
        after_save    :sync_heroku_domains
        after_destroy :remove_heroku_domains
      end

      protected

      def store_domains_to_remove_from_heroku
        @domains_to_remove = (self.domains_was || []) - [self.full_subdomain_was] - [self.full_subdomain] - self.domains_without_subdomain
      end

      def sync_heroku_domains
        # all the Heroku domains should also referenced in the site, if not then remove them from Heroku.
        (@domains_to_remove || []).each do |domain|
          if Locomotive::Heroku.domains.include?(domain)
            Locomotive::Heroku.remove_domain(domain)
          end
        end

        # Locomotive::Heroku.domains.each do |domain|
        #   unless self.domains_without_subdomain.include?(domain)
        #     Locomotive::Heroku.remove_domain(domain)
        #   end
        # end

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