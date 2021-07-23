require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users

  def setup
    @jsmith = User.find(2)
    @setting = Setting.plugin_account_lockout.dup
    Setting.plugin_account_lockout[:lockout_limit] = '3'
  end

  def teardown
    Setting.plugin_account_lockout = @setting
  end

  def test_pass_auth_failures_has_exceeded_the_limit_should_be_lockout
    limit_count = Setting.plugin_account_lockout[:lockout_limit].to_i
    limit_count.times do
      assert !@jsmith.lockout?
      @jsmith.check_password? 'bad'
    end
    assert @jsmith.lockout?
    assert !@jsmith.check_password?('jsmith')
  end

  def test_after_expired_date_pass_auth_should_succeed
    limit_count = Setting.plugin_account_lockout[:lockout_limit].to_i
    @jsmith.update_columns(lockout_expired_date: 1.second.ago)
    assert @jsmith.lockout_expired_date.present?
    assert @jsmith.check_password?('jsmith')
    assert @jsmith.lockout_expired_date.nil?
  end
end
