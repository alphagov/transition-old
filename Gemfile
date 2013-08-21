source 'https://rubygems.org'
source 'https://BnrJb6FZyzspBboNJzYZ@gem.fury.io/govuk/'

gem 'rails', '3.2.13'
gem 'exception_notification', '2.6.1'
gem 'unicorn'
gem 'mysql2'
gem 'aws-ses', require: 'aws/ses'

gem 'plek', '1.2.0'
gem 'gds-sso', '3.0.0'

gem 'therubyracer'
gem 'jquery-rails', '2.0.2' # TODO: Newer versions break publisher sortable parts. Will need attention.
gem 'jquery-ui-rails'
gem 'select2-rails'
gem 'htmlentities'
gem 'whenever'
gem 'acts_as_list'

gem 'activerecord-import'
gem 'rgarner-csv-mapper'
gem 'kramdown'
gem 'optic14n', '>= 0.0.4'

# Gems used only for assets and not required in production
# environments by default.
group :assets do
  gem 'sass'
  gem 'sass-rails', '~> 3.2'
  gem "bootstrap-sass", "2.3.2.1"
  gem 'uglifier', '>= 1.0.3'
end

group :test do
  gem 'capybara', '~> 2.1.0', require: false
  gem 'factory_girl_rails', '4.1.0'
  gem 'ci_reporter', '1.8.0'
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'webmock', require: false
  gem 'shoulda-matchers'
  gem 'launchy'
  gem 'selenium-webdriver'
end

group :development, :test do
  gem 'rspec-rails'
  # gem 'debugger'
end
