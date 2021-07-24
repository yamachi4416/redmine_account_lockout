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

  def test_password_change_should_succeed
    put(
      :update,
      :params => {
        :id => 2,
        :user => {
          :password => 'newpass123',
          :password_confirmation => 'newpass123'
        }
      }
    )
    u = User.find(2)
    assert u.check_password?('newpass123')
  end

  def test_lockedout_user_password_change_should_succeed
    u = User.find(2)
    u.update_columns(lockout_expired_date: 1.hours.since)
    assert u.lockout?
    put(
      :update,
      :params => {
        :id => 2,
        :user => {
          :password => 'newpass123',
          :password_confirmation => 'newpass123'
        }
      }
    )
    u = User.find(2)
    assert u.check_password?('newpass123')
    assert !u.lockout?
  end
end
