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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171207123001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "archived_messages", force: :cascade do |t|
    t.integer "offset", null: false
    t.string "topic", null: false
    t.integer "partition", null: false
    t.string "value", null: false
    t.string "key"
    t.integer "create_time"
    t.index ["offset"], name: "index_archived_messages_on_offset"
    t.index ["topic", "partition", "offset"], name: "index_archived_messages_on_topic_and_partition_and_offset", unique: true
  end

  create_table "candidates", primary_key: "key", id: :string, force: :cascade do |t|
    t.integer "vote_count", null: false
  end

end
