module RedmineIrcNotifications
  module IssuePatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable
        after_create :notify_irc_after_create
      end
    end

    module InstanceMethods
      private
      def notify_irc_after_create
        description = RedmineIrcNotifications::Helpers.truncate_words(self.description)

        RedmineIrcNotifications::IRC.speak "#{self.author.login} created issue \x033#{self.subject}\x03. Status: \x033#{self.status}\x03 Assigned: \x033#{self.assigned_to}\x03 http://#{Setting.host_name}/issues/#{self.id}"
      end
    end
  end
end
