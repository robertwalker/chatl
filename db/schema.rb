# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100219190323) do

  create_table "attendees", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "meeting_id"
    t.string   "rsvp",       :default => "Yes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attendees", ["user_id", "meeting_id"], :name => "idx_user_meeting", :unique => true

  create_table "data_files", :force => true do |t|
    t.string   "comment"
    t.string   "name"
    t.string   "content_type", :default => "application/octetstream"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meetings", :force => true do |t|
    t.integer  "venue_id"
    t.datetime "scheduled_at"
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "notification_sent"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "presentations", :force => true do |t|
    t.string   "title"
    t.date     "presented_on"
    t.text     "narrative"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "presented_by"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "social_networks", :force => true do |t|
    t.integer  "user_id",                        :null => false
    t.string   "network",                        :null => false
    t.string   "username",                       :null => false
    t.boolean  "make_public", :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                    :default => "passive"
    t.datetime "deleted_at"
    t.string   "first_name",                :limit => 100, :default => ""
    t.string   "last_name",                 :limit => 100, :default => ""
    t.string   "identity_url"
    t.datetime "logged_in_at"
    t.boolean  "subscribe_to_chatter",                     :default => false
  end

  add_index "users", ["identity_url"], :name => "index_users_on_identity_url", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "venues", :force => true do |t|
    t.string   "name"
    t.string   "street_address"
    t.string   "city",             :default => "Atlanta"
    t.string   "state",            :default => "GA"
    t.string   "zip"
    t.integer  "seating_capacity"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "map_url"
  end

end
