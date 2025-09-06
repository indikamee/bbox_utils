class RenameTicketCode < ActiveRecord::Migration[5.2]
  def change
    remove_column :tickets, :code, :string
    add_column :tickets, :seq, :integer
  end
end
