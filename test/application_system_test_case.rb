require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  Selenium::WebDriver::Chrome.driver_path = "/home/ziaulqamar/chromedriver"
end
