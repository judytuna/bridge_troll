class Event < ActiveRecord::Base
  belongs_to :location
  has_many :volunteerRsvpRoles
  has_many :users, :through => :volunteerRsvpRoles
  validates_presence_of :title
  validates_presence_of :date
end
