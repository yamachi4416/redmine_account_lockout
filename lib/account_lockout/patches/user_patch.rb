module AccountLockout::Patches
  module UserPatch
    def self.included(base) # :nodoc:
      base.class_eval do
        unloadable
      end

      base.send(:prepend, InstanceMethods)
    end

    module InstanceMethods

      def lockout?
        self.lockout_expired_date &&
          self.lockout_expired_date > DateTime.now
      end

      def check_password?(clear_password)
        checked = super
        if lockout? || !checked
          update_lockout
          return false
        end
        reset_lockout
        checked
      end

      def salt_password(clear_password)
        super
        reset_lockout
      end

      def reset_lockout
        update_columns(
          lockout_check_count: nil,
          lockout_failure_count: nil,
          lockout_expired_date: nil)
      end

      private

      def update_lockout
        count = self.lockout_check_count || 0
        limit_count = (Setting.plugin_account_lockout[:lockout_limit] || 10).to_i
        expired_minutes = (Setting.plugin_account_lockout[:lockout_period_minutes] || 15).to_i
        if (count + 1) >= limit_count || lockout?
          update_columns(
            lockout_check_count: 0,
            lockout_failure_count: (self.lockout_failure_count || count) + 1,
            lockout_expired_date: expired_minutes.minute.since)
        else
          update_columns(lockout_check_count: count + 1)
        end
      end
    end
  end
end

unless User.included_modules.include? AccountLockout::Patches::UserPatch
  User.send :include, AccountLockout::Patches::UserPatch
end
