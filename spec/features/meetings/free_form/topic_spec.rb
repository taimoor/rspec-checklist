require 'rails_helper'

#----------------------------------------------------------------------------------------------------
#   T O P I C   W I T H   N E W   M E E T I N G
#----------------------------------------------------------------------------------------------------
feature 'Topic with new meeting', js:true do
  before :all do
    with_registered_user
  end


  scenario 'with empty title on hover' do
    create_new_meeting
    create_first_topic('My first topic')

    topic = get_first_topic
    remove_title(topic)
    topic.hover
    verify_hidden_controls(topic['id'])
    page.save_screenshot('screenshot.png')
  end

end

#----------------------------------------------------------------------------------------------------
#   T O P I C   W I T H   S A M P L E   M E E T I N G
#----------------------------------------------------------------------------------------------------
feature 'Topic with sample meeting', js:true do

  before :all do
    with_registered_user
  end

  before :each do
    sample_meeting = FactoryGirl.create(:meeting, :with_sample_data)
    visit_meeting_page(sample_meeting.id)
  end

  scenario 'with title on hover' do
    topic = get_first_topic
    topic_id = topic['id']
    topic.set('Topic Title')
    topic.hover

    verify_item_controls_visibility(topic_id)
    page.save_screenshot('screenshot.png')
  end

  scenario 'with title' do
    topic = get_first_topic
    topic.set('Topic Title')
    hover_out_from_agenda_item
    verify_hidden_controls(topic['id'])
    page.save_screenshot('screenshot.png')
  end

  scenario 'when deleted children should also delete' do
    topic = get_first_topic
    topic_id = topic['id']
    topic.hover
    #TODO create note
    # create_note(topic_id)

    click_topic_drop_down(topic_id)
    click_topic_delete_button(topic_id)
    expect(page).not_to have_css('.children')
    page.save_screenshot('screenshot.png')
  end

  scenario 'cannot be converted if first topic of meeting' do
    topic = get_first_topic
    topic_id = topic['id']
    topic.set('Topic Title')
    # binding.pry
    dismiss_confirm do
      topic.send_keys(:alt,:control,'2')
    end

    within_element("#item-container-#{topic_id}") do
      expect(page).to have_css('.topic-div')
    end
    page.save_screenshot('screenshot.png')
  end

  scenario 'can be converted if not first topic of meeting' do
    topic = get_last_topic
    topic_id = topic['id']
    topic.set('Second Topic Title')
    topic.send_keys(:alt,:control,'3')

    within_element("#item-container-#{topic_id}") do
      expect(page).to have_css('.note-div')
      expect(page).not_to have_css('.topic-div')
    end
    page.save_screenshot('screenshot.png')
  end

  scenario 'when converted it will nest under previous topic' do
    topic = get_last_topic
    topic_id = topic['id']
    position = topic['data-topic-position'].to_i - 1
    previous_topic_id = first("div[data-topic-position='#{position}']")['id']

    topic.set('Second Topic Title')
    topic.send_keys(:alt,:control,'4')

    within_element("#item-container-#{topic_id}") do
      expect(page).to have_css('.decision-div')
      expect(page).not_to have_css('.topic-div')
    end

    parent_id = find_by_id("#{topic_id}")['data-parent-id']
    expect(parent_id).to eq(previous_topic_id)

    page.save_screenshot('screenshot.png')
  end

  scenario 'when converted to subtopic, its ndt children will become subtopic children' do
    topic = get_last_topic
    topic_id = topic['id']
    topic_ndt_children_count = page.all(".topic-ndt-#{topic_id}").size
    topic.set('Second Topic Title')
    topic.send_keys(:alt,:control,'2')

    within_element("#item-container-#{topic_id}") do
      expect(page).to have_css('.subtopic-div')
      expect(page).not_to have_css('.topic-div')
    end

    subtopic_ndt_children_count = page.all(".subtopic-ndt-#{topic_id}").size
    expect(subtopic_ndt_children_count).to eq(topic_ndt_children_count)

    page.save_screenshot('screenshot.png')
  end

  scenario 'when created all next items till next topic will be nested under it' do
    topic = get_first_topic
    topic_id = topic['id']
    topic_children = page.all("[data-parent-id=\"#{topic_id}\"]")
    first_child = topic_children[0]
    new_topic_id = first_child_id = first_child['id']
    #don't count children which will be created topic
    topic_children_count = topic_children.size - 1
    if first_child['class'].split(' ').include?('subtopic-div')
      subtopic_id = first_child['id']
      subtopic_children = page.all("[data-parent-id=\"#{subtopic_id}\"]")
      topic_children_count += subtopic_children.size
    end
    first_child.set('New Topic Title')
    first_child.send_keys(:alt,:control,'1')
    new_topic_children_count = page.all("[data-parent-id=\"#{new_topic_id}\"]").size

    within_element("#item-container-"+new_topic_id) do
      expect(page).to have_css('.topic-div')
    end

    expect(topic_children_count).to eq(new_topic_children_count)
    page.save_screenshot('screenshot.png')
  end

end

#----------------------------------------------------------------------------------------------------
#   T O P I C   S O R T I N G
#----------------------------------------------------------------------------------------------------
feature 'Topic Sorting', js:true do

  before :all do
    with_registered_user
  end

  before :each do
    sample_meeting = FactoryGirl.create(:meeting, :with_sample_data)
    visit_meeting_page(sample_meeting.id)
  end

  scenario 'when moved to topic' do
    source = get_nth_topic(1)
    source_id = source['id']
    target = get_nth_topic(0)
    before_move_source_children_count = get_children_count(source_id)
    drag_drop_agenda_item(source, target)
    after_move_source_children_count = get_children_count(source_id)

    expect(target['data-topic-position']).to be > source['data-topic-position']
    expect(after_move_source_children_count).to eq(before_move_source_children_count)
  end

  scenario 'when moved to subtopic' do
    source = get_nth_topic(1)
    source_id = source['id']
    target = get_nth_subtopic(0)
    target_previous_parent_topic = find_by_id(target['data-parent-id'])

    before_move_source_children_count = get_children_count(source_id)
    before_move_subtopics_count_in_subtopic_parent_topic = get_topic_subtopics_count(target_previous_parent_topic['id'])

    drag_drop_agenda_item(source, target)
    after_move_source_children_count = get_children_count(source_id)

    expect(target_previous_parent_topic['data-topic-position']).to be < source['data-topic-position']
    expect(after_move_source_children_count).to eq(before_move_source_children_count + before_move_subtopics_count_in_subtopic_parent_topic)
  end
  # scenario 'when converted then topic detail should destroy' do
  #   with_registered_user
  #   visit_meeting_page(meeting_id)
  #
  #   topic = get_first_topic
  #   topic_id = topic['id']
  #   topic.send_keys('topic')
  #   topic.click
  #   first("#conversion_bar > li:nth-child(2) > a").click
  #   # binding.pry
  #   # first("#topic-dropdown-#{topic_id}").click
  #   # first(:xpath, "//*[@id=\"item-container-#{topic_id}\"]/div[3]/div/ul/li/a[1]").click
  #   #
  #   #
  #
  #
  #
  #
  #   # binding.pry
  #
  #   # expect(page).not_to have_css('.children')
  #   page.save_screenshot('screenshot.png')
  # end


end
