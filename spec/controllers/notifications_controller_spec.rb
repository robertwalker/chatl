require 'spec_helper'

describe NotificationsController do
  before(:each) do
    @mock_venue = mock_model(Venue).as_null_object
    @mock_venue.stub!(:name).and_return("Venu name")
    @mock_venue.stub!(:notes).and_return("Venue notes")
    @mock_meeting = mock_model(Meeting)
    @mock_meeting.stub!(:title).and_return(@mock_venue)
    @mock_meeting.stub!(:venue).and_return(@mock_venue)
    @mock_meeting.stub!(:details).and_return("Meeting details")
    @mock_meeting.stub!(:scheduled_at).and_return(Time.now + 1.week)
    @mock_meeting.stub!(:send_notification?).and_return(true)
    @mock_meeting.stub!(:update_notification_sent).and_return(true)
    Meeting.stub!(:next_upcoming).and_return(@mock_meeting)
    MeetingMailer.stub!(:deliver_scheduled)
  end

  describe "POST 'scheduled'" do
    it "should be successful" do
      post 'scheduled'
      response.should be_success
    end

    it "should assign '@meeting'" do
      Meeting.should_receive(:next_upcoming).and_return(@mock_meeting)
      post 'scheduled'
      assigns(:meeting).should == @mock_meeting
    end

    it "sould send the scheduled email notification" do
      MeetingMailer.should_receive(:deliver_scheduled).with(@mock_meeting)
      post 'scheduled'
    end

    it "should render text 'Scheduled meeting message sent.'" do
      post 'scheduled'
      response.body.should == "Scheduled meeting message sent.\n"
    end
  end

  describe "POST 'reminder'" do
    it "should be successful" do
      post 'reminder'
      response.should be_success
    end

    it "should assign '@meeting'" do
      Meeting.should_receive(:next_upcoming).and_return(@mock_meeting)
      post 'reminder'
      assigns(:meeting).should == @mock_meeting
    end

    it "sould send the reminder email notification" do
      @mock_meeting.should_receive(:update_notification_sent).and_return(true)
      MeetingMailer.should_receive(:deliver_reminder).with(@mock_meeting)
      post 'reminder'
    end

    it "should render text 'Meeting reminder message sent.'" do
      post 'reminder'
      response.body.should == "Meeting reminder message sent.\n"
    end

    it "should not send notification if not due" do
      @mock_meeting.should_receive(:send_notification?).and_return(false)
      MeetingMailer.should_not_receive(:deliver_reminder)
      post 'reminder'
      response.body.should == "No meeting due for notification.\n"
    end
  end
end
