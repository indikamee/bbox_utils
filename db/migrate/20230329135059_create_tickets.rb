class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.references :event, foreign_key: true
      t.string :code
      t.string :ticket_type
      t.string :state
      t.float :price
      t.references :agent, null: true
      t.references :person, null: true

      t.timestamps
    end
  end
end
