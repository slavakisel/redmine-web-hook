require File.expand_path('../../../test_helper', __FILE__)

class AttachmentPatchTest < ActiveSupport::TestCase
  fixtures :users

  def setup_attachment
    user = User.generate!(:firstname => 'Test')
    User.current = user
    Attachment.new(container_type: 'Issue', container_id: 27,
                       file: uploaded_test_file("testfile.txt", "text/plain"),
                       author: user, content_type: 'a'*300)
  end

  def setup_mock(attachment)
    mock = MiniTest::Mock.new
    mock.expect :call, nil, [attachment.container_id, User.current.id]
    mock
  end

  test 'calls notifier after create' do
    attachment = setup_attachment
    mock = setup_mock(attachment)

    WebHook::Notifier.stub :perform, mock do
      attachment.save
    end
    mock.verify
  end

  test 'calls notifier after destroy' do
    attachment = setup_attachment
    attachment.save
    mock = setup_mock(attachment)

    stub_request(:post, /httpbin.org\/post/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: 'stubbed response', headers: {})

    WebHook::Notifier.stub :perform, mock do
      attachment.destroy
    end
    mock.verify
  end

  test '#should_notify?' do
    attachment = setup_attachment
    assert attachment.should_notify?

    attachment.container_type = 'Comment'
    assert !attachment.should_notify?
  end
end
