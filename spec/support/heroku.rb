ENV['MOCK_HEROKU'] = '1'

def start_heroku_app(params = {})
  Locomotive::Heroku.connection.post_app(params).body.tap do |data|
    name = data['name']
    Locomotive::Heroku.app_name = name

    ready = false
    until ready
      ready = Locomotive::Heroku.connection.request(:method => :put, :path => "/apps/#{name}/status").status == 201
    end

    Locomotive::Heroku.connection.post_addon(name, 'custom_domains:basic')
  end
end

def shutdown_heroku_app(name)
  Locomotive::Heroku.connection.delete_app(name) rescue nil
end

def with_app(params = {}, &block)
  begin
    data = start_heroku_app(params)
    @name = data['name']
    yield(data)
  ensure
    shutdown_heroku_app @name
  end
end