class AddTableIdToTicket < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :table_id, :integer
  end
end
