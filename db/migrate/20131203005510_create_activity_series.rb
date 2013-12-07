class CreateActivitySeries < ActiveRecord::Migration
  def change
    create_table :activity_series do |t|
	  t.integer :frequency, :default => 1
      t.string :period, :default => 'monthly'
	  t.datetime :start_time
      t.integer :month_num

      t.timestamps
    end
  end
end
