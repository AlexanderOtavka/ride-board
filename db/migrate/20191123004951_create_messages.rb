class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.references :ride,       null: false, foreign_key: true
      t.references :created_by, null: false, foreign_key: {to_table: :users}
      t.text :content,          null: false

      t.timestamps
    end
  end
end
