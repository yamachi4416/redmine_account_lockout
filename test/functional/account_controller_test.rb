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

  def test_login_with_after_expired_date_should_succeed
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

  def test_post_lost_password_with_token_should_succeed
    ActionMailer::Base.deliveries.clear
    token = Token.create!(:action => 'recovery', :user => @jsmith)
    post(
      :lost_password,
      :params => {
        :token => token.value,
        :new_password => 'newpass123',
        :new_password_confirmation => 'newpass123'
      }
    )
    assert_redirected_to '/login'
    @jsmith.reload
    assert @jsmith.check_password?('newpass123')
  end

  def test_post_lockedout_user_lost_password_with_token_should_succeed
    ActionMailer::Base.deliveries.clear
    @jsmith.update_columns(lockout_expired_date: 1.hours.since)
    token = Token.create!(:action => 'recovery', :user => @jsmith)
    post(
      :lost_password,
      :params => {
        :token => token.value,
        :new_password => 'newpass123',
        :new_password_confirmation => 'newpass123'
      }
    )
    assert_redirected_to '/login'
    @jsmith.reload
    assert @jsmith.check_password?('newpass123')
  end
end
