module AccountLockout::Patches
  module UsersHelperPatch
    def self.included(base) # :nodoc:
      base.class_eval do
        unloadable
      end
      base.send(:prepend, InstanceMethods)
    end

    module InstanceMethods
      def user_settings_tabs
        tabs = super
        tabs << {
          :name => 'account_lockout',
          :partial => 'account_lockout/users_tab',
          :label => :account_lockout_tab
        } if User.current.admin?
        tabs
      end
    end
  end
end

unless UsersHelper.included_modules.include? AccountLockout::Patches::UsersHelperPatch
  UsersHelper.send :include, AccountLockout::Patches::UsersHelperPatch
end
