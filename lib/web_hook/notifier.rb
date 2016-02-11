require 'uri'
require 'net/http'
require 'json'

module WebHook
  class Notifier
    def self.perform(issue_id, user_id)
      hook_url = Setting.plugin_redmine_web_hook['web_hook_url']
      return if hook_url.blank?

      uri = URI(hook_url)
      sender = Net::HTTP.new(uri.host, uri.port)
      sender.use_ssl = hook_url.include?('https')
      request = Net::HTTP::Post.new(uri.path)

      data = {
        issueid: issue_id,
        userid: user_id,
        datetime: Time.now
      }.to_json
      request.body = "[ #{data} ]"

      sender.request(request)
    end
  end
end
