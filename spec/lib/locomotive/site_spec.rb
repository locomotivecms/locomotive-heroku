require 'spec_helper'

describe 'Site enhanced by Heroku' do

  before(:each) do
    Locomotive::Heroku.stubs(:connection).returns(::Heroku::API.new(:mock => true))
    @app_data = start_heroku_app
    Locomotive.enable_heroku
    @site = FactoryGirl.build('valid site')
  end

  after(:each) do
    shutdown_heroku_app @app_data['name']
  end

  describe '#callbacks' do

    it 'tries to add/remove domains after saving a site' do
      @site.expects(:sync_heroku_domains)
      @site.save
    end

    it 'tries to remove domains after removing a site' do
      @site.expects(:remove_heroku_domains)
      @site.destroy
    end

  end

  describe '#syncing domains' do

    it 'does not sync if no changes' do
      Locomotive::Heroku.expects(:add_domain).never
      Locomotive::Heroku.expects(:remove_domain).never
      @site.save
    end

    it 'adds a new domain' do
      @site.domains = ['www.nocoffee.fr', 'nocoffee.fr']
      Locomotive::Heroku.expects(:add_domain).with('www.nocoffee.fr')
      Locomotive::Heroku.expects(:add_domain).with('nocoffee.fr')
      @site.save
    end

    it 'does not remove domains' do
      Locomotive::Heroku.stubs(:domains).returns(['blabla.fr'])
      @site.domains = ['www.nocoffee.fr', 'nocoffee.fr']
      Locomotive::Heroku.expects(:remove_domain).with('www.nocoffee.fr').never
      Locomotive::Heroku.expects(:remove_domain).with('blabla.fr').never
      @site.save
    end

    it 'removes useless domains' do
      Locomotive::Heroku.stubs(:domains).returns(['www.nocoffee.fr', 'nocoffee.fr', 'blabla.fr'])
      @site.stubs(:domains_was).returns(['www.nocoffee.fr', 'nocoffee.fr', 'blabla.fr'])
      @site.domains = ['www.nocoffee.fr', 'nocoffee.fr']
      Locomotive::Heroku.expects(:add_domain).never
      Locomotive::Heroku.expects(:remove_domain).with('blabla.fr')
      @site.save
    end

    it 'both adds and removes domains' do
      Locomotive::Heroku.stubs(:domains).returns(['www.nocoffee.fr', 'nocoffee.fr', 'blabla.fr'])
      @site.stubs(:domains_was).returns(['www.nocoffee.fr', 'nocoffee.fr', 'blabla.fr'])
      @site.domains = ['www.nocoffee.fr', 'nocoffee.fr', 'helloworld.fr']
      Locomotive::Heroku.expects(:add_domain).with('nocoffee.fr').never
      Locomotive::Heroku.expects(:add_domain).with('helloworld.fr')
      Locomotive::Heroku.expects(:remove_domain).with('blabla.fr')
      Locomotive::Heroku.expects(:remove_domain).with('nocoffee.fr').never
      @site.save
    end

  end

  describe '#removing' do

    it 'does not remove a domain if the site has no domains' do
      Locomotive::Heroku.expects(:add_domain).never
      Locomotive::Heroku.expects(:remove_domain).never
      @site.destroy
    end

    it 'removes all the domains' do
      Locomotive::Heroku.stubs(:domains).returns(['www.nocoffee.fr', 'nocoffee.fr'])
      @site.domains = ['www.nocoffee.fr', 'nocoffee.fr']
      @site.save && @site.reload
      %w(www.nocoffee.fr nocoffee.fr).each do |domain|
        Locomotive::Heroku.expects(:add_domain).with(domain).never
        Locomotive::Heroku.expects(:remove_domain).with(domain)
      end
      @site.destroy
    end

  end

end