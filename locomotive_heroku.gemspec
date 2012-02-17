$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'locomotive/heroku/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'locomotive_heroku'
  s.version     = Locomotive::Heroku::VERSION
  s.authors     = ['Didier Lafforgue']
  s.email       = ['didier@nocoffee.fr']
  s.homepage    = 'http://www.locomotivecms.com'
  s.summary     = 'Heroku for LocomotiveCMS'
  s.description = 'Enhance the LocomotiveCMS engine in order to make it run on Heroku'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['{test, spec}/**/*']

  s.add_dependency 'rails', '~> 3.2.1'
  s.add_dependency 'heroku-api', '~> 0.1.0'
end
