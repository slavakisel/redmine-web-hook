require 'web_hook/notifier'
require 'web_hook/patches/issue_patch'
require 'web_hook/patches/journal_patch'
require 'web_hook/patches/attachment_patch'

Redmine::Plugin.register :redmine_web_hook do
  name 'Redmine Web Hook plugin'
  author 'Slava K'
  description 'Plugin "listents" for certain events and performs HTTP post request with update details to web hook url.'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  settings default: { web_hook_url: '' }, partial: 'settings/web_hook_settings'
end
