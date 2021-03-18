class CreateUserManagerGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :user_manager_groups do |t|
      t.integer :user_manager_id
      t.integer :group_id
    end
  end
end
