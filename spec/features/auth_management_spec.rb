require 'rails_helper'

#----------------------------------------------------------------------------------------------------
#   L O G I N
#----------------------------------------------------------------------------------------------------
feature 'Signing in' do
  after(:each) do
    # Capybara.reset_sessions!
    # puts ' >>>> Capybara.reset_sessions! <<<<'
  end

  scenario 'with valid credentials' do
    with_registered_user

    #VERIFY
    expect(page).to have_content('Successfully authenticated')
    expect(page).not_to have_current_path(new_user_session_path)
  end

  scenario 'with invalid credentials' do
    do_login('invalid@invalid.com', 'In\/@1i)')

    #VERIFY
    expect(page).to have_content('Invalid email or password')
    expect(page).to have_current_path(new_user_session_path)
  end

end

#----------------------------------------------------------------------------------------------------
#   L O G O U T
#----------------------------------------------------------------------------------------------------
feature 'signing out' do

  scenario 'from dashboard', js:true do
    with_registered_user
    do_logout

    #VERIFY
    expect(page).to have_current_path(new_user_session_path)
  end

end
