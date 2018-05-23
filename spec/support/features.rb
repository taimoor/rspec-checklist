RSpec.configure do |config|
  config.include Features::SessionHelpers,    type: :feature
  config.include Features::MeetingHelpers,    type: :feature
  config.include Features::WebdriverHelpers,  type: :feature
end