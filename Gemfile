source "http://rubygems.org"

# Declare your gem's dependencies in heroku.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

group :development, :test do
# gem 'locomotive_cms', :path => '../../engine', :require => 'locomotive/engine'

  gem 'rspec-rails', '~> 2.8.0'
  gem 'shoulda-matchers'

  gem 'factory_girl_rails', '~> 1.6.0'
  gem 'mocha', '0.9.12' # :git => 'git://github.com/floehopper/mocha.git'

  gem 'database_cleaner'
end

group :assets do
  gem 'compass-rails'
end

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
