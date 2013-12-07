class CreateVolunteerHours < ActiveRecord::Migration
  def change
    create_table :volunteer_hours do |t|
	  t.integer :user_id
	  
      t.date :date_worked
      t.decimal :hours_worked
      t.integer :project

      t.timestamps
    end
	add_index :volunteer_hours, [:user_id, :updated_at]
  end
end
