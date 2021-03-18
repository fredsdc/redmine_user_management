class CreateUserManagerUcfs < ActiveRecord::Migration[5.2]
  def change
    create_table :user_manager_ucfs do |t|
      t.integer :user_manager_id
      t.integer :user_custom_field_id
    end
  end
end
