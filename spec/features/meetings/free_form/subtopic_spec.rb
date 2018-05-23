require 'rails_helper'

#----------------------------------------------------------------------------------------------------
#   S U B T O P I C
#----------------------------------------------------------------------------------------------------
feature 'Subtopic', js:true do

  before :all do
    with_registered_user
  end

  before :each do
    sample_meeting = FactoryGirl.create(:meeting, :with_sample_data)
    visit_meeting_page(sample_meeting.id)
  end

  scenario 'with title on  hover' do
    subtopic = get_first_subtopic
    subtopic.set('Subtopic Title')
    subtopic.hover

    verify_item_controls_visibility(subtopic['id'])

    page.save_screenshot('screenshot.png')
  end

  scenario 'with title' do
    subtopic = get_first_subtopic
    subtopic.set('Subtopic Title')
    hover_out_from_agenda_item
    verify_hidden_controls(subtopic['id'])
    page.save_screenshot('screenshot.png')
  end

  scenario 'with empty title on hover' do
    subtopic = get_first_subtopic
    remove_title(subtopic)
    subtopic.hover

    verify_hidden_controls(subtopic['id'])
    page.save_screenshot('screenshot.png')
  end
  scenario 'when converted to topic it will become next sibling of parent topic' do
    subtopic = get_first_subtopic
    subtopic_id = subtopic['id']
    parent_id = subtopic['data-parent-id']

    parent_topic_position = find_by_id(parent_id)['data-topic-position'].to_i

    subtopic.set('Subtopic Title')
    subtopic.send_keys(:alt,:control,'1')

    within_element("#item-container-#{subtopic_id}") do
      expect(page).to have_css('.topic-div')
      expect(page).not_to have_css('.subtopic-div')
    end

    new_topic_position = find_by_id(subtopic_id)['data-topic-position'].to_i
    expect(parent_topic_position).to eq(new_topic_position - 1)

    page.save_screenshot('screenshot.png')
  end

  scenario 'when first subtopic converted to note its children will become children of parent topic' do
    subtopic = get_first_subtopic
    subtopic_id = subtopic['id']
    parent_id = subtopic['data-parent-id']

    before_conversion_topic_children_count = page.all("[data-parent-id=\"#{parent_id}\"]").size
    subtopic_children_count = page.all("[data-parent-id=\"#{subtopic_id}\"]").size
    total_children_count = before_conversion_topic_children_count + subtopic_children_count

    subtopic.set('Subtopic Title')
    subtopic.send_keys(:alt,:control,'3')

    within_element("#item-container-#{subtopic_id}") do
      expect(page).to have_css('.note-div')
      expect(page).not_to have_css('.subtopic-div')
    end

    topic_children_count = page.all("[data-parent-id=\"#{parent_id}\"]").size
    expect(topic_children_count).to eq(total_children_count)

    page.save_screenshot('screenshot.png')
  end




  scenario 'when subtopic converted to note (ndt) its children will become children of parent topic or previous subtopic' do
    first_subtopic = get_first_subtopic
    first_subtopic_id = first_subtopic['id']
    first_subtopic_children_count = page.all("[data-parent-id=\"#{first_subtopic_id}\"]").size
    parent_id = first_subtopic['data-parent-id']
    topic_all_subtopics = page.all('.topic-subtopic-'+parent_id)
    topic_subtopics_count = topic_all_subtopics.size

    if(topic_subtopics_count==1)
      before_conversion_topic_children_count = page.all("[data-parent-id=\"#{parent_id}\"]").size
      total_children_count = before_conversion_topic_children_count + first_subtopic_children_count
      subtopic = first_subtopic
    else
      next_subtopic = topic_all_subtopics[1]
      next_subtopic_id = next_subtopic['id']
      next_subtopic_children_count = page.all("[data-parent-id=\"#{next_subtopic_id}\"]").size
      total_children_count = first_subtopic_children_count + next_subtopic_children_count + 1
      subtopic = next_subtopic
      parent_id = first_subtopic_id
    end
    subtopic_id = subtopic['id']
    subtopic.set('Subtopic Title')
    subtopic.send_keys(:alt,:control,'3')
    within_element("#item-container-#{subtopic_id}") do
      expect(page).to have_css('.note-div')
      expect(page).not_to have_css('.subtopic-div')
    end

    parent_children_count = page.all("[data-parent-id=\"#{parent_id}\"]").size
    expect(parent_children_count).to eq(total_children_count)

    page.save_screenshot('screenshot.png')
  end

  scenario 'when created all next items till next topic/subtopic will be nested under it' do
    subtopic = get_first_subtopic
    subtopic_id = subtopic['id']
    subtopic_children = page.all("[data-parent-id=\"#{subtopic_id}\"]")
    first_child = subtopic_children[0]
    new_subtopic_id = first_child['id']

    #don't count children which will be created subtopic
    subtopic_children_count = subtopic_children.size - 1

    first_child.set('New Subtopic')
    first_child.send_keys(:alt,:control,'2')
    new_subtopic_children_count = page.all("[data-parent-id=\"#{new_subtopic_id}\"]").size

    within_element("#item-container-"+new_subtopic_id) do
      expect(page).to have_css('.subtopic-div')
    end

    expect(subtopic_children_count).to eq(new_subtopic_children_count)
    page.save_screenshot('screenshot.png')
  end

end
