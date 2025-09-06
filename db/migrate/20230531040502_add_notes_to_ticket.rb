class AddNotesToTicket < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :notes, :string
  end
end
