require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/session'
# require 'capybara/spec/spec_helper'
# require 'capybara/spec/session/all_spec'


# include Capybara::Angular::DSL

Capybara.run_server = false
Capybara.default_host       = 'localhost:4000'
Capybara.app_host           = 'localhost:4000'
# Capybara.server_port        = 3000

Capybara.default_max_wait_time  = 3 # seconds
Capybara.exact = true # when it is false, they allow substring matches

Capybara.configure do |config|
  config.server = :puma
end

# Capybara::Webkit.configure do |config|
#   config.debug = true
#   config.block_unknown_urls
#   config.allow_url('*')
# end

Capybara.default_driver     = :selenium_firefox
Capybara.javascript_driver  = :selenium_firefox
Capybara.current_driver     = :selenium_firefox

# Capybara.session_name = 'DEFAULT_SESSION'

# RSpec.configure do |config|
#   config.append_after(:each) do
#     Capybara.reset_sessions!
#   end
# end