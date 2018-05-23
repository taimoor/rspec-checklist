module Features
  module WebdriverHelpers

    def wait
      $selenium_webdriver_wait ||= Selenium::WebDriver::Wait.new(:timeout => 10)
    end

    def zoom_to_view_fullpage
      page.driver.browser.find_element(css: 'html').send_keys([:control, '0'], [:control] + [:subtract] * 10)
    end

    def zoom_reset
      page.driver.browser.find_element(css: 'html').send_keys([:control, '0'])
    end

  end
end
