require 'test_helper'

class MeetingMailerTest < ActionMailer::TestCase
  test "scheduled_notification" do
    @expected.subject = 'MeetingMailer#scheduled_notification'
    @expected.body    = read_fixture('scheduled_notification')
    @expected.date    = Time.now

    assert_equal @expected.encoded, MeetingMailer.create_scheduled_notification(@expected.date).encoded
  end

  test "reminder" do
    @expected.subject = 'MeetingMailer#reminder'
    @expected.body    = read_fixture('reminder')
    @expected.date    = Time.now

    assert_equal @expected.encoded, MeetingMailer.create_reminder(@expected.date).encoded
  end

end
