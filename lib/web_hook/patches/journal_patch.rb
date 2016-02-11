module WebHook
  module Patches
    module JournalPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          # comment create notification is handled by issue
          # after_update callback, no need to catch event here
          # for the second time
          after_update :notify_about_update
        end
      end

      module InstanceMethods
        def notify_about_update
          WebHook::Notifier.send(journalized_id, User.current.id)
        end
      end
    end
  end
end

unless Journal.included_modules.include? WebHook::Patches::JournalPatch
  Journal.send(:include, WebHook::Patches::JournalPatch)
end
