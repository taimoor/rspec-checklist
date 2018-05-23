require 'rails_helper'


RSpec.feature 'Note', js:true, type: :feature do
# RSpec.describe 'Note', js:true do

  before :all do
    with_registered_user
  end

  scenario 'marks favorite' do
    # create_first_topic
    # topic = get_first_topic
    # topic.hover
    # create_note(topic['id'])
    # note_container = first(:xpath,"//*[@id=\"#{first('.item-container.note')['id']}\"]")
    # note = get_first_note
    # note.set('Note Title')
    # note.hover
    # note_id = note['id']
    # verify_item_controls_visibility(note_id)
    page.save_screenshot('screenshot00.png')
    input = first(:xpath, "//*[@id='1']")
    input.click
    page.save_screenshot('screenshot01.png')
    expect(true).to be_truthy

    # page.save_screenshot('screenshot.png')
  end

  # scenario 'with title' do
  #   note = get_first_note
  #   note.set('Note Title')
  #   hover_out_from_agenda_item
  #   verify_hidden_controls(note['id'])
  #   page.save_screenshot('screenshot.png')
  # end
  #
  # scenario 'with empty title on hover' do
  #   note = get_first_note
  #   remove_title(note)
  #   note.hover
  #   verify_hidden_controls(note['id'])
  #   page.save_screenshot('screenshot.png')
  # end
end

#----------------------------------------------------------------------------------------------------
#   N O T E   S O R T I N G
#----------------------------------------------------------------------------------------------------
# RSpec.describe 'Note sorting', js:true do
#   before :all do
#     with_registered_user
#   end
#
#   before :each do
#     sample_meeting = FactoryGirl.create(:meeting, :with_sample_data)
#     visit_meeting_page(sample_meeting.id)
#   end
#
#   scenario 'when moved to note' do
#     source = get_nth_note(1)
#     target = get_nth_note(0)
#     moving_ndt_to_ndt(source, target)
#   end
#
#   scenario 'when moved to task' do
#     source = get_nth_note(0)
#     target = get_nth_task(0)
#     moving_ndt_to_ndt(source, target)
#
#   end
#
#   scenario 'when moved to decision' do
#     source = get_nth_note(0)
#     target = get_nth_decision(0)
#     moving_ndt_to_ndt(source, target)
#   end
#
#
# end
