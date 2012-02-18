require 'spec_helper'

describe 'Heroku enabler' do

  before(:each) do
    Locomotive::Heroku.stubs(:connection).returns(::Heroku::API.new(:mock => true))
  end

  after(:all) do
    Locomotive.send(:remove_const, 'Site') if Locomotive.const_defined?('Site')
    load 'locomotive/site.rb'
  end

  it 'fetches the domains' do
    with_app do
      Locomotive::Heroku.expects(:domains)
      Locomotive.enable_heroku
    end
  end

  it 'disables the rack cache' do
    with_app do
      Locomotive.enable_heroku
      Locomotive.config.rack_cache.should be_false
    end
  end

  it 'enhances the Site model' do
    with_app do
      Locomotive.enable_heroku
      Locomotive::Site.should include_class_method :create_first_one_with_heroku
    end
  end

  it 'forces the domain and subdomain properties' do
    Locomotive.config.multi_sites = false
    with_app do
      Locomotive.enable_heroku
      Locomotive.config.manage_domains?.should be_true
      Locomotive.config.manage_subdomain?.should be_false
    end
  end

end