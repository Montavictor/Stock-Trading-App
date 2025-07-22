require "test_helper"

class AdminMailerTest < ActionMailer::TestCase
  test "account_approved" do
    mail = AdminMailer.account_approved
    assert_equal "Account approved", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
