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
      @user = Factory(:user)
    end

    it "should have a volunteer method" do
      @event.should respond_to(:volunteer)
    end
    
    it "should not create duplicate volunteer_rsvp_roles" do
      @event.volunteer(@user)

      duplicate_volunteer_rsvp_role = VolunteerRsvpRole.new(:user_id => @user.id, :event_id => @event.id, :attending => true)
      duplicate_volunteer_rsvp_role.should_not be_valid
       
    end
    
    it "should create a volunteer_rsvp_role" do
      lambda {        
      @event.volunteer(@user)
      }.should change(VolunteerRsvpRole, :count).by(1)
    end
     
    it "should give the new volunteer_rsvp_role with correct attributes" do
      @rsvp = @event.volunteer(@user)
      @rsvp.user_id.should == @user.id
      @rsvp.event_id.should == @event.id
      @rsvp.attending.should == true
    end    
  end
  
  describe "unvolunteer" do
    before do
      @event = Factory(:event)
      @user = Factory(:user)
    end
    
    it "should have an unvolunteer method" do
      @event.should respond_to(:unvolunteer)
    end
    
    it "should change the attending attribute to false" do
      @rsvp = @event.volunteer(@user)
      @rsvp.attending.should == true
      
      @event.unvolunteer(@user)
      changedStatus = @event.volunteerRsvpRoles.find_by_user_id(@user.id).attending 
      changedStatus.should == false 
    end
  end
  
  describe "volunteering?" do
    before do
      @event = Factory(:event)
      @user = Factory(:user)
    end
    
    it "should have a volunteering? method" do
      @event.should respond_to(:volunteering?)
    end
    
    it "should be true when a user is volunteering at an event" do
      @event.volunteer(@user)
      @event.volunteering?(@user).should == true        
    end
    
    it "should be false when a user is not volunteering at an event" do
      @event.volunteering?(@user).should == false        
    end
    
  end
end
