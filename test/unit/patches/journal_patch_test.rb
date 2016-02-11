require File.expand_path('../../../test_helper', __FILE__)

class JournalPatchTest < ActiveSupport::TestCase
  fixtures :issues, :users, :projects, :trackers, :projects_trackers, :issue_statuses, :enumerations

  test 'calls notifier after update' do
    user = User.generate!(:firstname => 'Test')
    User.current = user
    issue = Issue.create!(project_id: 1, tracker_id: 1, author_id: user.id,
                  status_id: 1, priority: IssuePriority.all.first,
                  subject: 'test_create')
    journal = Journal.create!(:journalized => Issue.first, :user => User.first)

    mock = MiniTest::Mock.new
    mock.expect :call, nil, [issue.id, user.id]
    WebHook::Notifier.stub :perform, mock do
      journal.notes = 'Lorem Ipsum'
      issue.save!
    end
    mock.verify
  end
end
