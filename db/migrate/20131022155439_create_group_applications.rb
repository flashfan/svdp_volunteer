class CreateGroupApplications < ActiveRecord::Migration
  def change
    create_table :group_applications do |t|
      t.string :group_name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :relationship
      t.string :emergency_name
      t.string :emergency_relationship
      t.string :emergency_phone
      t.string :emergency_email
      t.boolean :criminal_history
      t.text :explanation
	  t.integer :group_size
      t.text :group_members
      t.integer :user_id

      t.timestamps
    end
	add_index :group_applications, [:user_id, :updated_at]
  end
end
