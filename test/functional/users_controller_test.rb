require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < Redmine::ControllerTest
  fixtures :users, :email_addresses, :roles

  def setup
    User.current = nil
    @request.session[:user_id] = 1
  end

  def test_edit_account_lockout_tab
    get :edit, :params => { :id => 2, tab: 'account_lockout' }
    assert_response :success
    assert_select '#tab-account_lockout.selected'
    assert_select 'form[action="/users/2/lockout/reset"]'
  end
end
