require 'spec_helper'

describe NotificationsController do
  before(:each) do
    @mock_venue = mock_model(Venue).as_null_object
    @mock_venue.stub!(:name).and_return("Venu name")
    @mock_venue.stub!(:notes).and_return("Venue notes")
    @mock_meeting = mock_model(Meeting).as_null_object
    @mock_meeting.stub!(:venue).and_return(@mock_venue)
    @mock_meeting.stub!(:details).and_return("Meeting details")
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
      MeetingMailer.should_receive(:deliver_reminder).with(@mock_meeting)
      post 'reminder'
    end

    it "should render text 'Meeting reminder message sent.'" do
      post 'reminder'
      response.body.should == "Meeting reminder message sent.\n"
    end
  end
end
