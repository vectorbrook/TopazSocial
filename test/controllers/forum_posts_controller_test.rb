require 'test_helper'

class ForumPostsControllerTest < ActionController::TestCase
  setup do
    @forum_post = forum_posts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forum_posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create forum_post" do
    assert_difference('ForumPost.count') do
      post :create, forum_post: { body: @forum_post.body, description: @forum_post.description, sentiment: @forum_post.sentiment, status: @forum_post.status, user_id: @forum_post.user_id }
    end

    assert_redirected_to forum_post_path(assigns(:forum_post))
  end

  test "should show forum_post" do
    get :show, id: @forum_post
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @forum_post
    assert_response :success
  end

  test "should update forum_post" do
    patch :update, id: @forum_post, forum_post: { body: @forum_post.body, description: @forum_post.description, sentiment: @forum_post.sentiment, status: @forum_post.status, user_id: @forum_post.user_id }
    assert_redirected_to forum_post_path(assigns(:forum_post))
  end

  test "should destroy forum_post" do
    assert_difference('ForumPost.count', -1) do
      delete :destroy, id: @forum_post
    end

    assert_redirected_to forum_posts_path
  end
end
