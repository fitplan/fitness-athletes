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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151125220944) do

  create_table "athlete_clicks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "athlete_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "athlete_clicks", ["athlete_id"], name: "index_athlete_clicks_on_athlete_id"
  add_index "athlete_clicks", ["user_id"], name: "index_athlete_clicks_on_user_id"

  create_table "athletes", force: :cascade do |t|
    t.string   "title",                                        null: false
    t.integer  "user_id",                                      null: false
    t.string   "type",               default: "Athlete::Base", null: false
    t.text     "description"
    t.string   "url"
    t.string   "instagram_url"
    t.string   "avatar_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "clicks_count",       default: 0,               null: false
    t.integer  "cached_votes_total", default: 0
    t.integer  "cached_votes_score", default: 0
    t.integer  "cached_votes_up",    default: 0
    t.integer  "cached_votes_down",  default: 0
  end

  add_index "athletes", ["cached_votes_down"], name: "index_athletes_on_cached_votes_down"
  add_index "athletes", ["cached_votes_score"], name: "index_athletes_on_cached_votes_score"
  add_index "athletes", ["cached_votes_total"], name: "index_athletes_on_cached_votes_total"
  add_index "athletes", ["cached_votes_up"], name: "index_athletes_on_cached_votes_up"
  add_index "athletes", ["clicks_count"], name: "index_athletes_on_clicks_count"
  add_index "athletes", ["user_id"], name: "index_athletes_on_user_id"

  create_table "authorizations", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.text     "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "handle"
  end

  add_index "authorizations", ["provider", "uid"], name: "index_authorizations_on_provider_and_uid", unique: true
  add_index "authorizations", ["provider", "user_id"], name: "index_authorizations_on_provider_and_user_id", unique: true

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id",   default: 0
    t.string   "commentable_type"
    t.string   "title"
    t.text     "body"
    t.string   "subject"
    t.integer  "user_id",          default: 0, null: false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "email",              default: "", null: false
    t.integer  "sign_in_count",      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.text     "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "headline",           default: "", null: false
    t.string   "name",               default: "", null: false
    t.string   "slug"
    t.string   "avatar"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"

end
