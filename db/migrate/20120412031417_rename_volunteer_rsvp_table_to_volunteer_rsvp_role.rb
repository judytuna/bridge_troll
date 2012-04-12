class RenameVolunteerRsvpTableToVolunteerRsvpRole < ActiveRecord::Migration
  def change
    rename_table :volunteer_rsvps, :volunteer_rsvp_roles
  end
end
