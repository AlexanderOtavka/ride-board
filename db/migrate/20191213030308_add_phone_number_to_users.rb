class AddPhoneNumberToUsers < ActiveRecord::Migration[6.0]
  def up
    # Turn off sms for all users because we are about to delete all their phone
    # numbers, and that would violate our validations
    User.update_all notify_sms: nil

    add_column :users, :phone_number, :string
    remove_column :users, :phone
  end

  def down
    add_column :users, :phone, :integer
    remove_column :users, :phone_number
  end
end
