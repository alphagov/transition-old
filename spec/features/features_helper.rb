require 'spec_helper'

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 4

RSpec.configure do |config|

end

require_relative "support/helper_methods"
