class AddUserColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :lockout_check_count, :integer
    add_column :users, :lockout_failure_count, :integer
    add_column :users, :lockout_expired_date, :datetime
  end
end
