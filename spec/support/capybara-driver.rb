require 'selenium/webdriver'
require 'capybara/selenium/driver'
require 'capybara/selenium/node'

#----------------------------------------------------------------------------------------------------
#   Webkit
#----------------------------------------------------------------------------------------------------

#   Default webdriver is :webkit

#----------------------------------------------------------------------------------------------------
#   Firefox
#----------------------------------------------------------------------------------------------------

Capybara.register_driver :selenium_firefox do |app|
  desired_capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(marionette: false)
  Capybara::Selenium::Driver.new(app, browser: :firefox, desired_capabilities: desired_capabilities)
end

#----------------------------------------------------------------------------------------------------
#   Chrome
#----------------------------------------------------------------------------------------------------

Capybara.register_driver :selenium_chrome do |app|
  args = []
  args << '--window-size=320,480'

  profile = Selenium::WebDriver::Chrome::Profile.new
  profile['intl.accept_languages'] = 'en'

  Capybara::Selenium::Driver.new(app, browser: :chrome, args: args, profile: profile)
end
