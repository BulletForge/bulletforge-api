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

ActiveRecord::Schema.define(version: 2019_06_10_193651) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assets", id: :serial, force: :cascade do |t|
    t.string "attachment_file_name", limit: 255
    t.string "attachment_content_type", limit: 255
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer "attachable_id"
    t.string "attachable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "type", limit: 255
    t.string "s3_key", limit: 255
  end

  create_table "blocked_ips", id: :serial, force: :cascade do |t|
    t.string "ip_address", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "danmakufu_versions", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.string "permalink", limit: 255
    t.integer "category_id"
    t.integer "downloads", default: 0
    t.string "youtube_video_id", limit: 255
    t.integer "win_votes", default: 0
    t.integer "fail_votes", default: 0
    t.integer "danmakufu_version_id", default: 1
    t.boolean "unlisted", default: false
    t.string "version_number", limit: 255
    t.text "description"
    t.boolean "soft_deleted", default: false
    t.string "deleted_reason", limit: 255
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.integer "tagger_id"
    t.string "tagger_type", limit: 255
    t.string "taggable_type", limit: 255
    t.string "context", limit: 255
    t.datetime "created_at"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "login", limit: 255
    t.string "email", limit: 255
    t.string "crypted_password", limit: 255
    t.string "password_salt", limit: 255
    t.string "persistence_token", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "permalink", limit: 255
    t.boolean "admin"
    t.string "ip_address", limit: 255
    t.string "password_token", limit: 255
    t.datetime "password_token_expiration"
    t.boolean "suspicious", default: false
    t.string "password_digest", limit: 255
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
