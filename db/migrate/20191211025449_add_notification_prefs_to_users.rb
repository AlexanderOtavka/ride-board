class AddNotificationPrefsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :notify_sms, :boolean
    add_column :users, :notify_email, :boolean
  end
end
