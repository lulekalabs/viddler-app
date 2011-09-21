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

ActiveRecord::Schema.define(:version => 20110921190710) do

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.string   "ip"
    t.string   "user_agent"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["user_id"], :name => "index_sessions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "tags"
    t.string   "url"
    t.string   "thumbnail_url"
    t.string   "slug"
    t.integer  "user_id"
    t.integer  "session_id"
    t.string   "video_id"
    t.string   "source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "videos", ["session_id"], :name => "index_videos_on_session_id"
  add_index "videos", ["slug"], :name => "index_videos_on_slug"
  add_index "videos", ["user_id"], :name => "index_videos_on_user_id"
  add_index "videos", ["video_id"], :name => "index_videos_on_video_id"

end
