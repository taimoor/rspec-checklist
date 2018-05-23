require 'rails_helper'

#----------------------------------------------------------------------------------------------------
#   N O T E
#----------------------------------------------------------------------------------------------------
feature 'Note', js:true do

  before :all do
    with_registered_user
  end

  before :each do
    sample_meeting = FactoryGirl.create(:meeting, :with_sample_data)
    visit_meeting_page(sample_meeting.id)
  end

  scenario 'with title on  hover' do
    # create_first_topic
    # topic = get_first_topic
    # topic.hover
    # create_note(topic['id'])

    # binding.pry
    # note_container = first(:xpath,"//*[@id=\"#{first('.item-container.note')['id']}\"]")
    note = get_first_note
    note.set('Note Title')
    note.hover
    note_id = note['id']
    verify_item_controls_visibility(note_id)

    page.save_screenshot('screenshot.png')
  end

  scenario 'with title' do
    note = get_first_note
    note.set('Note Title')
    hover_out_from_agenda_item
    verify_hidden_controls(note['id'])
    page.save_screenshot('screenshot.png')
  end

  scenario 'with empty title on hover' do
    note = get_first_note
    remove_title(note)
    note.hover
    verify_hidden_controls(note['id'])
    page.save_screenshot('screenshot.png')
  end
end

#----------------------------------------------------------------------------------------------------
#   N O T E   S O R T I N G
#----------------------------------------------------------------------------------------------------
feature 'Note sorting', js:true do
  before :all do
    with_registered_user
  end

  before :each do
    sample_meeting = FactoryGirl.create(:meeting, :with_sample_data)
    visit_meeting_page(sample_meeting.id)
  end

  scenario 'when moved to note' do
    source = get_nth_note(1)
    target = get_nth_note(0)
    moving_ndt_to_ndt(source, target)
  end

  scenario 'when moved to task' do
    source = get_nth_note(0)
    target = get_nth_task(0)
    moving_ndt_to_ndt(source, target)

  end

  scenario 'when moved to decision' do
    source = get_nth_note(0)
    target = get_nth_decision(0)
    moving_ndt_to_ndt(source, target)
  end


end
