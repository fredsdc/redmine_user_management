class CreateUserManagers < ActiveRecord::Migration[5.2]
  def change
    create_table :user_managers do |t|
      t.string :name, :limit => 30, :default => "", :null => false
      t.string :description, :default => "", :null => false
      t.boolean :manage_login, :default => false, :null => false
      t.boolean :manage_password, :default => false, :null => false
      t.boolean :manage_name, :default => false, :null => false
      t.boolean :manage_mail, :default => false, :null => false
      t.boolean :manage_status, :default => false, :null => false
    end
  end
end
