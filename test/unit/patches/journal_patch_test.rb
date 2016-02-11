require File.expand_path('../../../test_helper', __FILE__)

class JournalPatchTest < ActiveSupport::TestCase
  fixtures :issues, :users, :projects, :trackers, :projects_trackers, :issue_statuses, :enumerations

  def setup_journal
    user = User.generate!(:firstname => 'Test')
    User.current = user
    issue = Issue.create!(project_id: 1, tracker_id: 1, author_id: user.id,
                  status_id: 1, priority: IssuePriority.all.first,
                  subject: 'test_create')
    Journal.create!(:journalized => Issue.first, :user => User.first)
  end

  def setup_mock(journal)
    mock = MiniTest::Mock.new
    mock.expect :call, nil, [journal.journalized_id, User.current.id]
  end

  test 'calls notifier after update' do
    journal = setup_journal
    mock = setup_mock(journal)

    WebHook::Notifier.stub :perform, mock do
      journal.notes = 'Lorem Ipsum'
      journal.save
    end
    mock.verify
  end

  test 'calls notifier after destroy' do
    journal = setup_journal
    mock = setup_mock(journal)

    WebHook::Notifier.stub :perform, mock do
      journal.destroy
    end
    mock.verify
  end
end
