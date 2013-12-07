class CreateIndividualApplications < ActiveRecord::Migration
  def change
    create_table :individual_applications do |t|
      t.integer :user_id
	  
	  t.date :date_of_birth
	  t.string :address
	  t.string :city
      t.string :state
      t.string :zip_code
	  t.string :faith
	  
	  t.string :emergency_name
      t.string :emergency_relationship
      t.string :emergency_phone
      t.string :emergency_email
	  
	  t.string :reference1_name
      t.string :reference1_relationship
      t.string :reference1_phone
      t.string :reference1_email
	  t.string :reference2_name
      t.string :reference2_relationship
      t.string :reference2_phone
      t.string :reference2_email
	  
	  t.boolean :criminal_history
	  t.boolean :dismiss_history
	  t.text :explanation

      t.timestamps
    end
	add_index :individual_applications, [:user_id, :updated_at]
  end
end
