require 'test_helper'

class LinksControllerTest < ActionController::TestCase

  setup do
    @link = links(:google)
  end

  # Requiring logged-in users

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to new_user_session_path
  end

  test "should redirect new when not logged in" do
    get :new
    assert_redirected_to new_user_session_path
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Link.count' do
      post :create, link: {  title: "Facebook", url: "www.facebook.com"}
    end
    assert_redirected_to new_user_session_path
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @link
    assert_redirected_to new_user_session_path
  end

  test "should redirect update when not logged in" do
    patch :update, id: @link, link: { url: "http://wwww.google.com" }
    assert_redirected_to new_user_session_path
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Link.count' do
      delete :destroy, id: @link
    end
    assert_redirected_to new_user_session_path
  end

  test "should redirect move_up when not logged in" do
    post :move_up, id: @link
    assert_redirected_to new_user_session_path
  end

  test "should redirect move_down when not logged in" do
    post :move_down, id: @link
    assert_redirected_to new_user_session_path
  end

  # Requiring the right user

  test "should redirect edit when logged in as wrong user" do
    sign_in users(:bob)
    link = links(:twitter)
    get :edit, id: link
    assert_equal 'Unauthorized access', flash[:alert]
    assert_redirected_to links_url
  end

  test "should redirect update when logged in as wrong user" do
    sign_in users(:bob)
    link = links(:twitter)
    patch :update, id: link, link: { url: "http://www.gmail.com" }
    assert_equal 'Unauthorized access', flash[:alert]
    assert_redirected_to links_url
  end

  test "should redirect destroy when logged in as wrong user" do
    sign_in users(:bob)
    link = links(:twitter)
    delete :destroy, id: link
    assert_equal 'Unauthorized access', flash[:alert]
    assert_redirected_to links_url
  end

  test "should redirect move_up when logged in as wrong user" do
    sign_in users(:bob)
    link = links(:twitter)
    put :move_up, id: link
    assert_equal 'Unauthorized access', flash[:alert]
    assert_redirected_to links_url
  end

  test "should redirect move_down when logged in as wrong user" do
    sign_in users(:bob)
    link = links(:twitter)
    put :move_down, id: link
    assert_equal 'Unauthorized access', flash[:alert]
    assert_redirected_to links_url
  end

  test "should redirect disable when logged in as wrong user" do
    sign_in users(:bob)
    link = links(:twitter)
    post :disable, id: link
    assert_equal 'Unauthorized access', flash[:alert]
    assert_redirected_to links_url
  end

  test "should redirect enable when logged in as wrong user" do
    sign_in users(:bob)
    link = links(:twitter)
    post :enable, id: link
    assert_equal 'Unauthorized access', flash[:alert]
    assert_redirected_to links_url
  end

  # Links index test

  test "index" do
    sign_in users(:bob)
    get :index
    assert_template 'links/index'
    assert_select 'tr', count: 4
    users(:bob).links.each do |link|
      assert_select 'a[href=?]', link.url, text: link.title
      assert_select 'a[href=?]', edit_link_path(link), text: "Edit"
      assert_select 'a[href=?]', link_path(link), text: "Delete"
      assert_select 'a[href=?]', move_up_link_path(link)
      assert_select 'a[href=?]', move_down_link_path(link)
    end
  end

  # Links profile test

  test "profile" do
    link = links(:google)
    get :profile, id: link.user
    assert_template 'links/profile'
    assert_select 'title', "bob"
    assert_select '.ui.five.cards' do
      assert_select '.ui.cards a.card, .ui.link.cards .card, a.ui.card, .ui.link.card', count: 2
    end
    users(:bob).links.where(disable: false).each do |link|
      assert_select 'a[href=?]', link.url, text: link.title
    end
  end

  # Links new test

  test "should get new" do
    sign_in users(:bob)
    get :new
    assert_response :success
  end

  # Links create test

  test "should create link" do
    sign_in users(:bob)
    assert_difference('Link.count') do
      post :create, link: { title: "apple", url: "http://www.apple.com" }
    end
    assert_redirected_to links_url
  end

  # Links edit test

  test "should get edit" do
    sign_in users(:bob)
    get :edit, id: @link
    assert_response :success
  end

  # Links update test

  test "should update link" do
    sign_in users(:bob)
    patch :update, id: @link, link: { url: "http://www.microsoft.com" }
    assert_redirected_to links_url
  end

  # Links destroy test

  test "should destroy link" do
    sign_in users(:bob)
    assert_difference('Link.count', -1) do
      delete :destroy, id: @link
    end
    assert_redirected_to links_url
  end

  # Links move_up test

  test "should move_up link" do
    sign_in users(:bob)
    links = users(:bob).links.order(position: :asc)
    link1 = links[0]
    link2 = links[1]
    assert_equal link1.url, links.first.url
    link2.move_higher
    new_links = users(:bob).links.order(position: :asc)
    assert_equal link2.url, new_links.first.url
  end

  # Links move_down test

  test "should move_down link" do
    sign_in users(:bob)
    links = users(:bob).links.order(position: :asc)
    link1 = links[0]
    link2 = links[1]
    assert_equal link1.url, links.first.url
    link1.move_lower
    new_links = users(:bob).links.order(position: :asc)
    assert_equal link2.url, new_links.first.url
  end

  # Links enable test

  test "should enable link" do
    sign_in users(:bob)
    get :profile, id: users(:bob)
    assert_select '.ui.five.cards' do
      assert_select '.ui.cards a.card, .ui.link.cards .card, a.ui.card, .ui.link.card', count: 2
    end
    post :enable, id: links(:instagram)
    get :profile, id: users(:bob)
    assert_select '.ui.five.cards' do
      assert_select '.ui.cards a.card, .ui.link.cards .card, a.ui.card, .ui.link.card', count: 3
    end
  end

  # Links disable test

  test "should disable link" do
    sign_in users(:bob)
    get :profile, id: users(:bob)
    assert_select '.ui.five.cards' do
      assert_select '.ui.cards a.card, .ui.link.cards .card, a.ui.card, .ui.link.card', count: 2
    end
    post :disable, id: links(:google)
    get :profile, id: users(:bob)
    assert_select '.ui.five.cards' do
      assert_select '.ui.cards a.card, .ui.link.cards .card, a.ui.card, .ui.link.card', count: 1
    end
  end

  # Links no subsctiption test

  test "with no subsctiption should not index" do
    sign_in users(:leo)
    get :index
    assert_response :redirect
  end

  # Links active subscription test

  test "with subscription should access index" do
    sign_in users(:paul)
    get :index
    assert_response :success
  end

  test "with 20 links should not access new and create" do
    sign_in users(:kate)
    get :profile, id: users(:kate).id
    assert_select '.ui.five.cards' do
      assert_select '.ui.cards a.card, .ui.link.cards .card, a.ui.card, .ui.link.card', count: 20
    end
    get :new
    assert_response :redirect
    assert_no_difference('Link.count') do
      post :create, link: { title: "apple", url: "http://www.apple.com" }
    end
  end

  # Links canceled and end_date > Time.now subscription test

  test "canceled_later should access new and create" do
    sign_in users(:janet)
    get :profile, id: users(:janet).id
    assert_select '.ui.five.cards' do
      assert_select '.ui.cards a.card, .ui.link.cards .card, a.ui.card, .ui.link.card', count: 10
    end
    get :new
    assert_response :success
    assert_difference('Link.count') do
      post :create, link: { title: "apple", url: "http://www.apple.com" }
    end
  end

  test "canceled_later with 20 links should not access new and create" do
    sign_in users(:chris)
    get :profile, id: users(:chris).id
    assert_select '.ui.five.cards' do
      assert_select '.ui.cards a.card, .ui.link.cards .card, a.ui.card, .ui.link.card', count: 20
    end
    get :new
    assert_response :redirect
    assert_no_difference('Link.count') do
      post :create, link: { title: "apple", url: "http://www.apple.com" }
    end
  end

  # Links canceled and end_date < Time.now subscription test

  test "canceled_now should not access new and create" do
    sign_in users(:troy)
    get :profile, id: users(:troy).id
    assert_select '.ui.five.cards' do
      assert_select '.ui.cards a.card, .ui.link.cards .card, a.ui.card, .ui.link.card', count: 5
    end
    get :new
    assert_response :redirect
    assert_no_difference('Link.count') do
      post :create, link: { title: "apple", url: "http://www.apple.com" }
    end
  end

  # Links past_due subscription test

  test "past_due with 5 links should access new and create" do
    sign_in users(:max)
    get :profile, id: users(:max).id
    assert_select '.ui.five.cards' do
      assert_select '.ui.cards a.card, .ui.link.cards .card, a.ui.card, .ui.link.card', count: 5
    end
    get :new
    assert_response :success
    assert_difference('Link.count') do
      post :create, link: { title: "apple", url: "http://www.apple.com" }
    end
  end

  test "past_due with 20 links should not access new and create" do
    sign_in users(:fox)
    get :profile, id: users(:fox).id
    assert_select '.ui.five.cards' do
      assert_select '.ui.cards a.card, .ui.link.cards .card, a.ui.card, .ui.link.card', count: 20
    end
    get :new
    assert_response :redirect
    assert_no_difference('Link.count') do
      post :create, link: { title: "apple", url: "http://www.apple.com" }
    end
  end
end