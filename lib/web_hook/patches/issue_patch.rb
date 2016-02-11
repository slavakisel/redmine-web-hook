module WebHook
  module Patches
    module IssuePatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          after_update :notify_about_update
        end
      end

      module InstanceMethods
        def notify_about_update
          WebHook::Notifier.perform(id, User.current.id)
        end
      end
    end
  end
end

unless Issue.included_modules.include? WebHook::Patches::IssuePatch
  Issue.send(:include, WebHook::Patches::IssuePatch)
end
