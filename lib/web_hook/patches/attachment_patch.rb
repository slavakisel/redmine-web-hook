# if @attachment.container.is_a?
module WebHook
  module Patches
    module AttachmentPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          after_create :notify_about_add, if: :should_notify?
          after_destroy :notify_about_delete, if: :should_notify?
        end
      end

      module InstanceMethods
        def should_notify?
          container_type == 'Issue'
        end

        def notify_about_add
          WebHook::Notifier.perform(container_id, author_id)
        end

        def notify_about_delete
          WebHook::Notifier.perform(container_id, User.current.id)
        end
      end
    end
  end
end

unless Attachment.included_modules.include? WebHook::Patches::AttachmentPatch
  Attachment.send(:include, WebHook::Patches::AttachmentPatch)
end
