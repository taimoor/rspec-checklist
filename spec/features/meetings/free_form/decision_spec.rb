require 'rails_helper'

#----------------------------------------------------------------------------------------------------
#   D E C I S I O N
#----------------------------------------------------------------------------------------------------
feature 'Decision', js:true do

  before :all do
    with_registered_user
  end

  before :each do
    sample_meeting = FactoryGirl.create(:meeting, :with_sample_data)
    visit_meeting_page(sample_meeting.id)
  end

  scenario 'with title on  hover' do
    decision = get_first_decision
    decision.set('Decision Title')
    decision.hover

    verify_item_controls_visibility(decision['id'])

    page.save_screenshot('screenshot.png')
  end

  scenario 'with title' do
    decision = get_first_decision
    decision.set('Decision Title')
    hover_out_from_agenda_item
    verify_hidden_controls(decision['id'])
    page.save_screenshot('screenshot.png')
  end

  scenario 'with empty title on hover' do
    decision = get_first_decision
    remove_title(decision)
    decision.hover

    verify_hidden_controls(decision['id'])
    page.save_screenshot('screenshot.png')
  end

end

#----------------------------------------------------------------------------------------------------
#   D E C I S I O N   S O R T I N G
#----------------------------------------------------------------------------------------------------
feature 'Decision sorting', js:true do
  before :all do
    with_registered_user
  end

  before :each do
    sample_meeting = FactoryGirl.create(:meeting, :with_sample_data)
    visit_meeting_page(sample_meeting.id)
  end

  scenario 'when moved to note' do
    source = get_nth_decision(0)
    target = get_nth_note(0)
    moving_ndt_to_ndt(source, target)
  end

  scenario 'when moved to task' do
    source = get_nth_decision(0)
    target = get_nth_task(0)
    moving_ndt_to_ndt(source, target)

  end

  scenario 'when moved to decision' do
    source = get_nth_decision(1)
    target = get_nth_decision(0)
    moving_ndt_to_ndt(source, target)
  end

end
