require File.dirname(__FILE__) + '/../test_helper'

class AccountControllerTest < Redmine::ControllerTest
  fixtures :users, :email_addresses, :roles

  def setup
    @jsmith = User.find(2)
    @setting = Setting.plugin_account_lockout.dup
    User.current = nil
    Setting.plugin_account_lockout[:lockout_limit] = '3'
  end

  def teardown
    Setting.plugin_account_lockout = @setting
  end

  def test_login_with_failures_has_exceeded_the_limit_should_be_lockout
    limit_count = Setting.plugin_account_lockout[:lockout_limit].to_i
    limit_count.times do
      post(
        :login,
        :params => {
          :username => 'jsmith',
          :password => 'bad'
        }
      )
      assert_response :success
      assert_select 'div.flash.error', :text => /Invalid user or password/
    end

    post(
      :login,
      :params => {
        :username => 'jsmith',
        :password => 'jsmith'
      }
    )
    assert_response :success
    assert_select 'div.flash.error', :text => /Invalid user or password/
  end

  def test_login_with_after_expired_date_login_should_succeed
    limit_count = Setting.plugin_account_lockout[:lockout_limit].to_i
    @jsmith.update_columns(lockout_expired_date: 1.second.ago)
    post(
      :login,
      :params => {
        :username => 'jsmith',
        :password => 'jsmith'
      }
    )
    assert_response 302
  end
end
