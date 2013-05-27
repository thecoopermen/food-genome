require 'spec_helper'

describe ApplicationController do

  subject { ApplicationController.new }

  describe "#current_user" do

    it "should return a user object if the session contains a valid login token" do
      user = create(:user, login_token: 'valid_token')
      subject.should_receive(:session).twice.and_return(login_token: 'valid_token')
      subject.send(:current_user).should == user
    end

    it "should return nil if the session contains an invalid login token" do
      subject.should_receive(:session).twice.and_return(login_token: 'invalid_token')
      subject.send(:current_user).should be_nil
    end

    it "should return nil if the session contains no login token" do
      subject.should_receive(:session).and_return({})
      subject.send(:current_user).should be_nil
    end
  end
end
