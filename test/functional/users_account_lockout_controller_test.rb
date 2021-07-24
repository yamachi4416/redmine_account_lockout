require File.dirname(__FILE__) + '/../test_helper'

class UsersAccountLockoutControllerTest < Redmine::ControllerTest
  fixtures :users, :email_addresses, :roles

  def setup
    User.current = nil
    @admin = User.find(1)
    @jsmith = User.find(2)
    @dlopper = User.find(3)
    @request.session[:user_id] = nil
  end

  def test_without_admin_should_reject
    @request.session[:user_id] = @dlopper.id
    patch :reset, :params => { :user_id => @jsmith }

    assert_response :forbidden
  end

  def test_without_admin_should_not_unlockout
    @jsmith.update_columns(lockout_expired_date: 1.hours.since)
    assert @jsmith.lockout?

    @request.session[:user_id] = @dlopper.id
    patch :reset, :params => { :user_id => @jsmith }

    @jsmith.reload
    assert @jsmith.lockout?
  end

  def test_with_admin_should_unlockout
    @jsmith.update_columns(lockout_expired_date: 1.hours.since)
    assert @jsmith.lockout?

    @request.session[:user_id] = @admin.id
    patch :reset, :params => { :user_id => @jsmith }

    @jsmith.reload
    assert !@jsmith.lockout?
  end
end
