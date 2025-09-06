class AddTicketUniqueConstraint < ActiveRecord::Migration[5.2]
  def change
    add_index :tickets, [:event_id, :ticket_type, :seq], unique: true
  end
end
