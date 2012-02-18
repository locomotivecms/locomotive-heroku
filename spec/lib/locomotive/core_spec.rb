require 'spec_helper'

describe 'Heroku core' do

  before(:each) do
    Locomotive.config.hosting = {}
    reset_config
  end

  after(:all) do
    reset_config
  end

  describe '#connection' do

    it 'raises an exception if no API key has been provided' do
      lambda do
        Locomotive::Heroku.connection
      end.should raise_error(RuntimeError, 'The Heroku API key is mandatory')
    end

    it 'accepts the API key from the locomotive config file' do
      Locomotive.config.hosting = { :api_key => '12345' }
      lambda do
        Locomotive::Heroku.connection
      end.should_not raise_error
    end

    it 'accepts the API key from the ENV variables' do
      ENV['HEROKU_API_KEY'] = '12345'
      lambda do
        Locomotive::Heroku.connection
      end.should_not raise_error
      ENV.delete('HEROKU_API_KEY')
    end

  end

  describe '#application' do

    it 'raises an exception if no app name has been provided' do
      lambda do
        Locomotive::Heroku.app_name
      end.should raise_error(RuntimeError, 'The Heroku application name is mandatory')
    end

    it 'accepts the name from the locomotive config file' do
      Locomotive.config.hosting = { :app_name => 'locomotive' }
      lambda do
        Locomotive::Heroku.app_name.should == 'locomotive'
      end.should_not raise_error
    end

    it 'accepts the name from the ENV variables' do
      ENV['APP_NAME'] = 'locomotive_new'
      lambda do
        Locomotive::Heroku.app_name.should == 'locomotive_new'
      end.should_not raise_error
      ENV.delete('APP_NAME')
    end

  end

  describe '#domains' do

    before(:each) do
      Locomotive::Heroku.stubs(:connection).returns(::Heroku::API.new(:mock => true))
    end

    it 'lists the domains' do
      with_app do
        Locomotive::Heroku.domains.should be_empty
      end
    end

    it 'adds a domain' do
      with_app do
        Locomotive::Heroku.domains
        Locomotive::Heroku.add_domain('nocoffee.fr')
        Locomotive::Heroku.domains.should == ['nocoffee.fr']
      end
    end

    it 'removes a domain' do
      with_app do
        Locomotive::Heroku.domains
        %w(nocoffee.fr locomotivecms.com).each { |name| Locomotive::Heroku.add_domain(name) }
        Locomotive::Heroku.remove_domain('nocoffee.fr')
        Locomotive::Heroku.domains.should == ['locomotivecms.com']
      end
    end

  end

  def reset_config
    Locomotive::Heroku.connection = nil
    Locomotive::Heroku.app_name = nil
    Locomotive::Heroku.domains = nil
  end

end