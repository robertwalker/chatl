require 'spec_helper'

describe NotificationsController do
  describe "POST 'scheduled'" do
    before(:each) do
      @mock_meeting = mock_model(Meeting)
      Meeting.stub!(:next_upcoming).and_return(@mock_meeting)
      MeetingMailer.stub!(:deliver_scheduled)
    end

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

    it "should render text 'Meeting reminder message sent.'" do
      post 'reminder'
      response.body.should == "Meeting reminder message sent.\n"
    end
  end
end
