class Event < ActiveRecord::Base
  belongs_to :location
  has_many :volunteerRsvpRoles, :foreign_key => "event_id"
  has_many :users, :through => :volunteerRsvpRoles
  validates_presence_of :title
  validates_presence_of :date
  
    
  def volunteer(user)
    @rsvp = VolunteerRsvpRole.find_or_create_by_event_id_and_user_id(self.id, user.id)
    @rsvp.attending = true
    @rsvp.save
    @rsvp
  end

  def unvolunteer(user)
    @attr = {:event_id => self.id, :user_id => user.id}
    VolunteerRsvpRole.where(@attr).first.update_attributes!(:attending => false)
  end
  
  def volunteering?(user)
    @attr = {:event_id => self.id, :user_id => user.id, :attending => true}
    VolunteerRsvpRole.where(@attr).present? 
  end
end
