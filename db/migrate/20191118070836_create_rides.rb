class CreateRides < ActiveRecord::Migration[6.0]
  def change
    create_table :rides do |t|
      t.references :start_location, null: false, foreign_key: {to_table: :locations}
      t.datetime :start_datetime,   null: false
      t.references :end_location,   null: false, foreign_key: {to_table: :locations}
      t.datetime :end_datetime
      t.references :driver,                      foreign_key: {to_table: :users}
      t.references :created_by,     null: false, foreign_key: {to_table: :users}
      t.decimal :price

      t.timestamps
    end
  end
end
