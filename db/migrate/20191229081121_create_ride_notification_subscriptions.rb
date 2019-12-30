class CreateRideNotificationSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :ride_notification_subscriptions do |t|
      t.references :ride, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :ride_notification_subscriptions, [:ride_id, :user_id], unique: true
  end
end
