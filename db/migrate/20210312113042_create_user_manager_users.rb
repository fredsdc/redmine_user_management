class CreateUserManagerUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :user_manager_users do |t|
      t.integer :user_manager_id
      t.integer :principal_id
    end
  end
end
