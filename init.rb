Redmine::Plugin.register :account_lockout do
  directory File.join(File.dirname(__FILE__))
  name 'Account Lockout plugin'
  author 'yamachi4416'
  description 'Account Lockout plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/yamachi4416/redmine_account_lockout'
  requires_redmine version_or_higher: '4.0'

  settings partial: 'account_lockout/settings',
    default: {
      lockout_limit: 10,
      lockout_period_minutes: 15
    }
end

require 'account_lockout/patches/user_patch'
require 'account_lockout/patches/users_helper_patch'
