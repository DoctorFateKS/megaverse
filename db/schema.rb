# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_08_14_183730) do
  create_table "mentions", force: :cascade do |t|
    t.integer "topic_id", null: false
    t.string "character_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id", "character_name"], name: "index_mentions_on_topic_id_and_character_name", unique: true
    t.index ["topic_id"], name: "index_mentions_on_topic_id"
  end

  create_table "stories", force: :cascade do |t|
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_stories_on_slug", unique: true
  end

  create_table "topics", force: :cascade do |t|
    t.string "guid"
    t.string "title"
    t.string "link"
    t.string "creator"
    t.string "category"
    t.text "description"
    t.datetime "pub_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "chapter_number"
    t.string "date_in_universe"
    t.string "lieu"
    t.string "outfit"
    t.string "tw"
    t.string "playlist"
    t.datetime "parsed_at"
    t.integer "story_id"
    t.index ["guid"], name: "index_topics_on_guid", unique: true
    t.index ["story_id"], name: "index_topics_on_story_id"
  end

  add_foreign_key "mentions", "topics"
  add_foreign_key "topics", "stories"
end
