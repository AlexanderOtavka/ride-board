class AddDrivesToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :drives, :boolean
  end
end
