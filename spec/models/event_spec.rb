require 'spec_helper'

describe Event do

  describe "volunteer rsvps role" do
    before do
      @event = Factory(:event)
    end
    
    it "should have a volunteer_rsvp_role method" do
      @event.should respond_to(:volunteerRsvpRoles)
    end   
  end
   
  describe "volunteer" do
    before do
      @event = Factory(:event)
    end

    it "should have a volunteer! method" do
      @event.should respond_to(:volunteer!)
    end
    
    it "should not create duplicate volunteer_rsvp_roles" do
      @user = Factory(:user)
      @event.volunteer!(@user)
      
      duplicate_volunteer_rsvp_role = VolunteerRsvpRole.new(:user_id => @user.id, :event_id => @event.id, :attending => true)
      duplicate_volunteer_rsvp_role.should_not be_valid
       
    end
    
    it "should create a volunteer_rsvp_role" do
      @user = Factory(:user)
      lambda {        
      @event.volunteer!(@user)
      }.should change(VolunteerRsvpRole, :count).by(1)
    end
     
    it "should give the new volunteer_rsvp_role with correct attributes" do
      @user = Factory(:user)
      @volunteer_rsvp_role = @event.volunteer!(@user)
      @volunteer_rsvp_role.user_id.should == @user.id
      @volunteer_rsvp_role.event_id.should == @event.id
      @volunteer_rsvp_role.attending.should == true
    end    
  end
  
#  describe "unvolunteer" do
#      it "should have an unvolunteer! method" do
#      @event.should respond_to(:unvolunteer!)
#      end
#  end
end
