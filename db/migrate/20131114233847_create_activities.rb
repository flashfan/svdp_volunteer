class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :user_id
	  t.integer :activity_series_id
	  
	  t.datetime :start_time
	  t.decimal :hour_num
	  t.integer :project
	  t.text :remark

      t.timestamps
    end
  end
end
