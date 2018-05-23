module Features
  module SessionHelpers

    def with_guest_user
      do_logout unless logged_out?
    end

    def with_registered_user
      do_login('user@domain.com', 'password', true)
      expect(page).not_to have_current_path(new_user_session_path)
    end

    def do_login(username, password, force=true)
      do_logout if force

      unless @current_test_user.present?
        @current_test_user = User.where(email: username).first

        visit new_user_session_path # visit login_2_path #TODO here we can visit another light weight page to test if user is logged in
        if logged_out?
          within_element('form') do |login_form|
            fill_in 'Email', :with => username
            fill_in 'Password', :with => password
            click_button 'Sign in'
          end
        end
      end
    end

    def logged_in?
      page.has_css?(current_user_in_topmenu_css, visible:false)
    end

    def current_test_user
      binding.pry
      @current_test_user
    end

    def self.current_test_user
      User.find_by_email('user@domain.com')
    end

    def do_logout
      visit root_path unless current_path.present?
      if logged_in?
        first(current_user_in_topmenu_css).click
        click_link 'Sign Out'
        @current_test_user = nil
      end
    end

    def logged_out?
      !logged_in?
    end



    private

    def current_user_in_topmenu_css
      '#main-nav-bar .dropdown .username'
    end

  end
end