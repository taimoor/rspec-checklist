require 'rails_helper'

#----------------------------------------------------------------------------------------------------
#   H O M E   P A G E
#----------------------------------------------------------------------------------------------------
feature 'Home Page' do

  scenario 'not allowed for visitors' do
    visit root_path

    #VERIFY
    expect(page).to have_current_path(new_user_session_path)
  end

  scenario 'dashboard' do
    with_registered_user

    #VERIFY
    expect(page).not_to have_current_path(new_user_session_path)
  end
  
end
