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
      post :create, link: { url: "www.facebook.com" }
    end
    assert_redirected_to new_user_session_path
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @link
    assert_redirected_to new_user_session_path
  end

  test "should redirect update when not logged in" do
    patch :update, id: @link, link: { url: "wwww.instagram.com" }
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
    patch :update, id: link, link: { url: "www.gmail.com" }
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
    post :move_up, id: link
    assert_equal 'Unauthorized access', flash[:alert]
    assert_redirected_to links_url
  end

  test "should redirect move_down when logged in as wrong user" do
    sign_in users(:bob)
    link = links(:twitter)
    post :move_down, id: link
    assert_equal 'Unauthorized access', flash[:alert]
    assert_redirected_to links_url
  end

  # Links index test

  test "index" do
    sign_in users(:bob)
    get :index
    assert_template 'links/index'
    assert_select 'tr', count: 2
    users(:bob).links.each do |link|
      assert_select 'a[href=?]', link.url, text: link.url
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
    assert_select 'a[href=?]', "/#{link.user.username}", "singlelink.me/#{link.user.username}"
    assert_select 'ul.list-group' do
      assert_select 'li', count: 2
    end
    users(:bob).links.each do |link|
      assert_select 'a[href=?]', link.url, text: link.url
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
      post :create, link: { url: "http://www.apple.com" }
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
    links = users(:bob).links.rank(:row_order)
    link1 = links[0]
    link2 = links[1]
    assert_equal link1.url, links.first.url
    post :move_up, id: link2
    new_links = users(:bob).links.rank(:row_order)
    assert_equal link2.url, new_links.first.url
  end

  # Links move_down test

  test "should move_down link" do
    sign_in users(:bob)
    links = users(:bob).links.rank(:row_order)
    link1 = links[0]
    link2 = links[1]
    assert_equal link1.url, links.first.url
    post :move_down, id: link1
    new_links = users(:bob).links.rank(:row_order)
    assert_equal link2.url, new_links.first.url
  end
end
