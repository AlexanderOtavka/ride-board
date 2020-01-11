class AddAppToRideNotificationSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :ride_notification_subscriptions, :app, :integer,
               null: false, default: 0
  end
end
