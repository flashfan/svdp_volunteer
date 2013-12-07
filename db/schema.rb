# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131205233019) do

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "activity_series_id"
    t.datetime "start_time"
    t.decimal  "hour_num"
    t.integer  "project"
    t.text     "remark"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "activity_series", :force => true do |t|
    t.integer  "frequency",  :default => 1
    t.string   "period",     :default => "monthly"
    t.datetime "start_time"
    t.integer  "month_num"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "group_applications", :force => true do |t|
    t.string   "group_name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "relationship"
    t.string   "emergency_name"
    t.string   "emergency_relationship"
    t.string   "emergency_phone"
    t.string   "emergency_email"
    t.boolean  "criminal_history"
    t.text     "explanation"
    t.integer  "group_size"
    t.text     "group_members"
    t.integer  "user_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "group_applications", ["user_id", "updated_at"], :name => "index_group_applications_on_user_id_and_updated_at"

  create_table "individual_applications", :force => true do |t|
    t.integer  "user_id"
    t.date     "date_of_birth"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "faith"
    t.string   "emergency_name"
    t.string   "emergency_relationship"
    t.string   "emergency_phone"
    t.string   "emergency_email"
    t.string   "reference1_name"
    t.string   "reference1_relationship"
    t.string   "reference1_phone"
    t.string   "reference1_email"
    t.string   "reference2_name"
    t.string   "reference2_relationship"
    t.string   "reference2_phone"
    t.string   "reference2_email"
    t.boolean  "criminal_history"
    t.boolean  "dismiss_history"
    t.text     "explanation"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "individual_applications", ["user_id", "updated_at"], :name => "index_individual_applications_on_user_id_and_updated_at"

  create_table "periods", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "password_digest"
    t.string   "contact_preference"
    t.string   "remember_token"
    t.integer  "preference_project"
    t.integer  "preference_period"
    t.integer  "preference_type"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "admin",              :default => false
    t.integer  "status",             :default => 1
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "volunteer_hours", :force => true do |t|
    t.integer  "user_id"
    t.date     "date_worked"
    t.decimal  "hours_worked"
    t.integer  "project"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "volunteer_hours", ["user_id", "updated_at"], :name => "index_volunteer_hours_on_user_id_and_updated_at"

end
