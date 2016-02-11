require File.expand_path('../../test_helper', __FILE__)

class NotifierTest < ActiveSupport::TestCase
  test '#perform does not perform request when web_hook_url is not present' do
    Setting.plugin_redmine_web_hook['web_hook_url'] = ''

    assert_nil WebHook::Notifier.perform(1, 1)
  end

  test '#perform performs request when web_hook_url is present' do
    Setting.plugin_redmine_web_hook['web_hook_url'] = 'http://httpbin.org/post'
    stub_request(:post, /httpbin.org\/post/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: 'stubbed response', headers: {})

    response = WebHook::Notifier.perform(1, 1)
    assert_equal '200', response.code
  end
end
