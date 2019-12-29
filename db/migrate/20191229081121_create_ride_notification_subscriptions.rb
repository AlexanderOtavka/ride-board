class CreateRideNotificationSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :ride_notification_subscriptions do |t|
      t.references :ride, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
