require 'test_helper'
class SummaryTest < ActionDispatch::IntegrationTest

  test 'should verify user can mark restaurant as favorit and summary page is updated' do
    Favorite.destroy_all
    user = users(:one)
    restaurant = restaurants(:one)
    sign_in user

    summary_page_favorit_res(0)

    get '/restaurants'
    assert_response :success

    assert_difference('Favorite.count', 1) do
      patch '/favorite', params:{ id: restaurant.id, checked: 'true'}
      assert_response :success
    end

    summary_page_favorit_res(1, restaurant)
  end

  private

  def summary_page_favorit_res(count, restaurant = nil)
  get '/user_summary'
    assert_response :success

    assert_select 'ul' do
      assert_select 'li', count
      if count > 0
        assert_select "a[href='/restaurants/#{restaurant.id}']", restaurant.name
      end
    end

  end
end