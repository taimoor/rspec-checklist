require "application_system_test_case"

class RestaurantsTest < ApplicationSystemTestCase

  test 'should verify user can vote restaurant' do
    restaurant = restaurants(:one)
    user = users(:one)
    assert_equal restaurant.user_votes.first.upvote, 1
    assert_equal restaurant.user_votes.first.downvote, 1

    sign_in user
    visit restaurants_url

    page.first("button[id='#{restaurant.id}']").click
    assert_text 'Restaurant was successfully updated.'

    assert_equal restaurant.user_votes.first.upvote, 2
    assert_equal restaurant.user_votes.first.downvote, 1
  end


  test 'should verify user can mark restaurant as favorite' do
    restaurant = restaurants(:two)
    user = users(:one)
    assert_empty restaurant.favorites.where(user_id: user.id)

    sign_in user
    visit restaurants_url

    check restaurant.id
    assert_text 'Action completed successfully'

    assert_equal restaurant.favorites.where(user_id: user.id).first.favorite_res, true
  end

  test 'should verify user can uncheck favorite restaurant' do
    restaurant = restaurants(:one)
    user = users(:one)
    assert restaurant.favorites.where(user_id: user.id)

    sign_in user
    visit restaurants_url

    uncheck restaurant.id # page.first('input[type=checkbox]').click
    assert_text 'Action completed successfully'

    assert_not restaurant.favorites.where(user_id: user.id).first.favorite_res
  end
end
