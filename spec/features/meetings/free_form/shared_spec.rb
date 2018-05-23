require 'rails_helper'

#----------------------------------------------------------------------------------------------------
#   A G E N D A   I T E M S
#----------------------------------------------------------------------------------------------------
feature 'AgendaItems', js:true do

  before :all do
    with_registered_user
  end

  before :each do
    sample_meeting = FactoryGirl.create(:meeting, :with_sample_data)
    visit_meeting_page(sample_meeting.id)
  end

  scenario 'conversion button should work if item is focused' do
    note = get_first_note
    note.set('Note Title!')
    verify_conversion_buttons_enabled
    page.save_screenshot('screenshot.png')
  end

  scenario 'conversion button should not work if item not focused' do
    hover_out_from_agenda_item
    verify_conversion_buttons_disabled
    page.save_screenshot('screenshot.png')
  end
  # scenario 'conversion' do
  #   with_registered_user
  #   visit_meeting_page(146896)
  #   note = get_first_note
  #   note.set('Note Title111212')
  #
  #   menu= first("#conversion_bar li:nth-child(1) a")
  #   menu.hover
  #   sleep(2)
  #   menu.click
  #   sleep(5)
  #   verify_conversion_buttons_enabled
  #   page.save_screenshot('screenshot.png')
  # end

end