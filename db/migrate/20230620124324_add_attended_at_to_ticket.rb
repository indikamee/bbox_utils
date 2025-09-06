class AddAttendedAtToTicket < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :attended_at, :datetime
  end
end
