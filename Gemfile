source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2'

# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.5.3'

# Use to send mails
gem 'mailgun-ruby'

# Use Redis adapter to run Action Cable in production
gem 'connection_pool'
gem 'redis', '~> 4.0'
gem 'redis-objects'
gem 'sidekiq', '~> 5.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.4.6', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

# Use JWT auth
gem 'jwt'
gem 'jwt_extended', '~> 0.1.3'

# Use spreadsheet gem for excel
gem 'spreadsheet'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Use test framework
  gem 'rspec-rails', '~> 4.0.0'
  # Use to create test data
  gem 'factory_bot_rails', '~> 5.2.0'
  # Use to load fake data
  gem 'ffaker', '~> 2.14.0'
end

group :development do
  gem 'listen', '~> 3.1.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
