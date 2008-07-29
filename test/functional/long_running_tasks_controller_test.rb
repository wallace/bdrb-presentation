require 'test_helper'

class LongRunningTasksControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:long_running_tasks)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_long_running_task
    assert_difference('LongRunningTask.count') do
      post :create, :long_running_task => { }
    end

    assert_redirected_to long_running_task_path(assigns(:long_running_task))
  end

  def test_should_show_long_running_task
    get :show, :id => long_running_tasks(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => long_running_tasks(:one).id
    assert_response :success
  end

  def test_should_update_long_running_task
    put :update, :id => long_running_tasks(:one).id, :long_running_task => { }
    assert_redirected_to long_running_task_path(assigns(:long_running_task))
  end

  def test_should_destroy_long_running_task
    assert_difference('LongRunningTask.count', -1) do
      delete :destroy, :id => long_running_tasks(:one).id
    end

    assert_redirected_to long_running_tasks_path
  end
end
