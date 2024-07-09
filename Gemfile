# Gemfile
source "https://rubygems.org"

ruby "3.1.2"
gem "rails", "~> 7.1.3", ">= 7.1.3.4"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails", "~> 1.2.3"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "redis", ">= 4.0.1"
gem "redis-rails" # Ensure this is included for Redis session store
gem "bootstrap", "~> 5.2"
gem "devise"
gem "autoprefixer-rails"
gem "font-awesome-sass", "~> 6.1"
gem "simple_form", github: "heartcombo/simple_form"
gem "sassc-rails"
gem "pundit"
gem "faker"
gem "flatpickr"
gem "geocoder"
gem "httparty"
gem "http"
gem "cloudinary"
gem "terser"
gem "sidekiq"
gem "bootsnap", require: false # Ensure bootsnap is included

group :development, :test do
  gem "dotenv-rails"
  gem "debug", platforms: %i[ mri mswin mswin64 mingw x64_mingw ]
end

group :development do
  gem "web-console"
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

# Include the following to handle sessions with Redis
gem 'redis-actionpack'
