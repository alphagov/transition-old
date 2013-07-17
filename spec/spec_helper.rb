# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.include FactoryGirl::Syntax::Methods

  # to turn deferred garbage collection on temporarily, run: export DEFERRED_GARBAGE_COLLECTION=true
  # or DGC=true
  # to turn on permanently, add a line to .bash_login or .bashrc: export DEFERRED_GARBAGE_COLLECTION=true
  # and then run: source {path of file}
  dgc = ENV['DEFERRED_GARBAGE_COLLECTION'].present? || ENV['DGC'].present?
  puts "Deferred garbage collection is #{dgc ? 'on' : 'off'}"
  if dgc
    config.before(:all) do
      DeferredGarbageCollection.start
    end
    config.after(:all) do
      DeferredGarbageCollection.reconsider
    end
  end
end

def fixture_file(filename)
  File.join(File.dirname(__FILE__), 'fixtures', filename)
end