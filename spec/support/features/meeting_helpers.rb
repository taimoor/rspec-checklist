module Features
  module MeetingHelpers

    #----------------------------------------------------------------------------------------------------
    #   Meeting
    #----------------------------------------------------------------------------------------------------

    def create_new_meeting
      # Create new meeting from quick create button in navbar
      within_element '#main-nav-bar' do
        find('#main-nav-bar .create-new-button a').click
        click_link 'New Meeting'
      end
      zoom_to_view_fullpage #TODO need to resolve this issue https://github.com/SeleniumHQ/selenium/issues/1202, for temp solution I zoom the screen to 30%

      # confirm to continue
      within_element '#new_meeting_dialog' do
        click_on 'Continue, create meeting in MeetingKing'
      end
    end

    def visit_meeting_page(meeting_id)
      # puts "---------- visit meeting path with id: #{meeting_id} ----------"
      visit v3_meeting_path(meeting_id)
      zoom_to_view_fullpage #TODO need to resolve this issue https://github.com/SeleniumHQ/selenium/issues/1202, for temp solution I zoom the screen to 30%

      if page.has_css? '.modal-footer'
        within_element('.modal-footer') do
          link_to_click = 'Stay at Free Form at my own risk'
          click_link link_to_click
        end
      end
      sleep(3) # wait for loading complete
    end
    
    def drag_drop_agenda_item(source, destination)
      driver = page.driver.browser

      draggable = source.native
      droppable = destination.native

      driver.action.move_to(draggable).perform
      page.should have_selector('.fa-arrows')


      drag_icon = first('.fa-arrows').native
      driver.action.click_and_hold(drag_icon).move_to(droppable).release(drag_icon).click(droppable).perform
    end

    def scroll_to(element)
      page.execute_script("window.scrollTo(#{element.native.location.x}, #{element.native.location.y})")
    end

    def add_new_agenda_item_below(agenda_item, new_title)
      driver = page.driver.browser

      agenda_item.hover
      first('#meeting_items_tree span.icon-for-insert-item').click
      sleep(3)
      driver.find_element(css: '#meeting_items_tree .focused-item [contenteditable]').set(new_title)
    end

    def wait_for_synced
      wait.until { page.driver.browser.find_element(id: 'ntp-meeting-status').text.downcase.include?('synced') }
    end

    #----------------------------------------------------------------------------------------------------
    #   Title
    #----------------------------------------------------------------------------------------------------

    def remove_title(element)
      element.set "temp"
      element.set "\b"
    end
    #----------------------------------------------------------------------------------------------------
    #CREAT ITEMS METHODS
    #----------------------------------------------------------------------------------------------------

    def create_first_topic(content='First Topic')
      within_element(meeting_item_tree_selector) do
        topic = first(:xpath, "//*[@id=\"meeting_items_tree\"]/ol/li/div/div[2]/div[2]")
        topic.set(content)
        expect(page).to have_content(content)
      end
    end

    def create_note(topic_id)
      first(".icon-for-insert-item.fa-plus-circle.icons-"+topic_id).click
    end

    #----------------------------------------------------------------------------------------------------
    #GET ITEMS METHODS
    #----------------------------------------------------------------------------------------------------
    def get_first_topic
      first('.topic-div')
    end
    def get_last_topic
      last = page.all('.topic-div').last
      last['id']==get_first_topic['id'] ? nil : last
    end

    def get_first_subtopic
      first('.subtopic-div')
    end

    def get_first_note
      first("div.title.note-div")
    end

    def get_nth_note(index)
      get_nth_item('note',index)
    end

    def get_nth_task(index)
      get_nth_item('task',index)
    end

    def get_nth_decision(index)
      get_nth_item('decision',index)
    end

    def get_nth_topic(index)
      get_nth_item('topic',index)
    end

    def get_nth_subtopic(index)
      get_nth_item('subtopic',index)
    end

    def get_nth_item(type,index)
      page.all("div.title.#{type}-div")[index]
    end

    def get_first_task
      first("div.title.task-div")
    end

    def get_first_decision
      first("div.title.decision-div")
    end

    def get_children(parent_id)
      page.all("[data-parent-id=\"#{parent_id}\"]")
    end
    def get_children_count(parent_id)
      get_children(parent_id).size
    end
    def get_topic_subtopics_count(parent_id)
      page.all(".subtopic-div[data-parent-id=\"#{parent_id}\"]").size
    end
    #----------------------------------------------------------------------------------------------------
    #CLICK EVENTS
    #----------------------------------------------------------------------------------------------------
    def click_topic_drop_down(topic_id)
      first("#topic-dropdown-#{topic_id}").click
    end
    def click_topic_delete_button(topic_id)
      accept_alert do
        first(:xpath, "//*[@id=\"item-container-#{topic_id}\"]/div[3]/div/ul/li/a[3]").click
      end
    end
    #----------------------------------------------------------------------------------------------------
    #VIEWS SELECTOR METHODS
    #----------------------------------------------------------------------------------------------------
    def meeting_item_tree_selector
      '#meeting_items_tree'
    end

    #----------------------------------------------------------------------------------------------------
    #EXPECTOR METHODS
    #----------------------------------------------------------------------------------------------------

    def verify_item_controls_visibility(item_id)
      item_container = find(:xpath,"//*[@id=\"item-container-#{item_id}\"]")
      expect(item_container).to have_css(".left-menu-container.icons-#{item_id}.visible")
      expect(item_container).to have_css(".rightMenu.icons-#{item_id}.visible")
    end

    def verify_hidden_controls(item_id)

      within_element(:xpath,"//*[@id=\"item-container-#{item_id}\"]") do

        expect(page).not_to have_xpath("//*[@id=\"topic-dropdown-#{item_id}\"]")
        puts "---Inside within"
        expect(page).not_to have_css(".angular-ui-tree-handle")
        expect(page).not_to have_css(".fa-minus")
        expect(page).not_to have_css(".fa-plus")

      end

    end

    def verify_conversion_buttons_enabled
      expect(page).not_to have_css(".convert_agenda_buttons")
    end

    def verify_conversion_buttons_disabled
      expect(page).to have_css(".convert_agenda_buttons")
    end

    #HOVER METHODS
    #
    def hover_out_from_agenda_item
      topic=get_first_topic
      topic.click
      click_topic_drop_down(topic['id'])
      first('.token-input-list-paracas').hover
    end

    #EXPECTATION METHODS & SHARED CODE
    def moving_ndt_to_ndt(source, target)
      target_parent_id = target['data-parent-id']
      source_id = source['id']
      before_move_source_parent_id = source['data-parent-id']
      source_sibling_count = get_children_count(before_move_source_parent_id)
      target_sibling_count = get_children_count(target_parent_id)

      if source['data-parent-id'] == target_parent_id
        target_sibling_count -= 1
        source_sibling_count += 1
      end

      drag_drop_agenda_item(source, target)
      source = find_by_id(source_id)
      after_move_target_sibling_count = get_children_count(target_parent_id)
      after_move_source_prev_parent_children_count = get_children_count(before_move_source_parent_id)


      expect(target_parent_id).to eq(source['data-parent-id'])
      expect(after_move_target_sibling_count).to be > target_sibling_count
      expect(after_move_source_prev_parent_children_count).to be < source_sibling_count
    end

  end
end
