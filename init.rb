Redmine::Plugin.register :account_lockout do
  directory File.join(Redmine::Plugin.directory, File.basename(File.dirname(__FILE__)))
  name 'Account Lockout plugin'
  author 'yamachi4416'
  description 'Account Lockout plugin for Redmine'
  version '0.0.1'

  settings partial: 'account_lockout/settings',
    default: {
      lockout_limit: 10,
      lockout_period_minutes: 15
    }
end

require 'account_lockout/patches/user_patch'
require 'account_lockout/patches/users_helper_patch'
