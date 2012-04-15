class AddIndexToVolunteerRsvpRoles < ActiveRecord::Migration
  def change
    add_index(:volunteer_rsvp_roles, [:user_id, :event_id], :unique => true)
  end
end
