class Event < ActiveRecord::Base
  belongs_to :location
  has_many :volunteerRsvpRoles
  has_many :users, :through => :volunteerRsvpRoles
  validates_presence_of :title
  validates_presence_of :date
  
  def volunteer(user)
    redirect_to "/events" and return if !user_signed_in?

    opts = {:event_id => params[:id], :user_id => current_user.id}
    @rsvp = VolunteerRsvpRole.where(opts).first || VolunteerRsvpRole.new(opts)
    @rsvp.attending = true

    if @rsvp.save
      redirect_to events_path, notice: 'Thanks for volunteering!'
    else
      redirect_to events_path, notice: 'You are already registered to volunteer for the event!'
    end
  end

  def unvolunteer(user)
    @rsvp = VolunteerRsvpRole.where(:event_id => params[:id], :user_id => current_user).first
    @events = Event.all
    respond_to do |format|
      if not @rsvp.nil? and @rsvp.update_attribute(:attending, false)
        format.html { redirect_to events_path, notice: 'Sorry to hear you can not volunteer. We hope you can make it to our next event!' }
        #redirect_to events
      else
        format.html { redirect_to events_path, notice: 'You are not signed up to volunteer for this event' }
      end
    end
  end
end
