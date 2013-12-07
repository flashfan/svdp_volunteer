class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :password_digest
      t.string :contact_preference
      t.string :remember_token
	  
	  t.integer :preference_project
	  t.integer :preference_period
	  t.integer :preference_type

      t.timestamps
    end
	add_index :users, :email, unique: true
	add_index :users, :remember_token
	add_column :users, :admin, :boolean, default: false
	add_column :users, :status, :integer, default: 1
  end
end
