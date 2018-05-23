require 'rails_helper'

#----------------------------------------------------------------------------------------------------
#   T A S K
#----------------------------------------------------------------------------------------------------
feature 'Task', js:true do

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
    task = get_first_task
    task.set('Task Title')
    task.hover

    task_id = task['id']
    verify_item_controls_visibility(task_id)

    page.save_screenshot('screenshot.png')
  end

  scenario 'with title' do
    task = get_first_task

    task.set('Task Title')
    hover_out_from_agenda_item
    verify_hidden_controls(task['id'])
    page.save_screenshot('screenshot.png')
  end

  scenario 'with empty title on hover' do
    task = get_first_task
    remove_title(task)
    task.hover

    verify_hidden_controls(task['id'])
    page.save_screenshot('screenshot.png')
  end

  scenario 'show task detail if title is present' do
    task = get_first_task
    task.set('task title')

    expect(page).to have_css('#item-container-'+task['id']+' > div.node-content > a')
    page.save_screenshot('screenshot.png')
  end

  scenario 'hide task detail if title is empty' do
    task = get_first_task
    remove_title(task)

    expect(page).not_to have_css('#item-container-'+task['id']+' > div.node-content > a')
    page.save_screenshot('screenshot.png')
  end
end

#----------------------------------------------------------------------------------------------------
#   T A S K   S O R T I N G
#----------------------------------------------------------------------------------------------------
feature 'Task sorting', js:true do
  before :all do
    with_registered_user
  end

  before :each do
    sample_meeting = FactoryGirl.create(:meeting, :with_sample_data)
    visit_meeting_page(sample_meeting.id)
  end

  scenario 'when moved to note' do
    source = get_nth_task(0)
    target = get_nth_note(0)
    moving_ndt_to_ndt(source, target)
  end

  scenario 'when moved to task' do
    source = get_nth_task(1)
    target = get_nth_task(0)
    moving_ndt_to_ndt(source, target)

  end

  scenario 'when moved to decision' do
    source = get_nth_task(0)
    target = get_nth_decision(0)
    moving_ndt_to_ndt(source, target)
  end

end
