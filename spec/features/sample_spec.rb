require 'rails_helper'

#----------------------------------------------------------------------------------------------------
#   S A M P L E S
#----------------------------------------------------------------------------------------------------
feature 'Samples', js: true do

  # https://github.com/teamcapybara/capybara#modals
  scenario 'interaction with browser alerts', js:true do
    visit new_user_session_path

    page.accept_alert do
      page.execute_script("alert('Test message.')")
    end
  end

  # keyboard native keys
  scenario 'keyboard native keys', js:true do
    with_registered_user

    driver.find_element(css: 'html').send_keys([:control, '0'], [:control] + [:subtract] * 7) # zoom in to 30 %
    sleep(5)
    driver.find_element(css: 'html').send_keys([:control, '0']) # zoom reset to 100%
  end

  # drag drop
  scenario 'drag drop', js:true do
    with_registered_user
    visit_meeting_page(146935)

    source        = first('.note', text:'Note 2 under topic 1')
    destination   = first('.note', text: 'Note 2 under topic 2')
    drag_drop_agenda_item(source, destination)

    expect(page).to have_content('Topic 1')
    wait_for_synced
  end

  # new note test
  scenario 'new note' do
    require 'securerandom'
    random_string = SecureRandom.hex

    with_registered_user
    visit_meeting_page(146935)
    add_new_agenda_item_below(page.all('.topic-div')[1], "new text #{random_string}")

    wait_for_synced
  end

  # new note test
  scenario 'solution for data overflow issue' do
    with_registered_user
    visit_meeting_page(146936)
    # binding.pry

    source          = first('.note-div')
    dest_idx        = 1 #page.all('.note-div').count - 1
    destination     = page.all('.note-div')[dest_idx]
    drag_drop_agenda_item(page, source, destination)
  end

end
