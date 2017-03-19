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

ActiveRecord::Schema.define(version: 20170319094628) do

  create_table "artists", force: :cascade do |t|
    t.string   "name",              null: false
    t.string   "genres"
    t.string   "spotify_artist_id", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "song_id"
    t.integer  "user_id"
    t.         "user"
    t.string   "type_of_artist"
    t.string   "origin"
    t.index ["song_id"], name: "index_artists_on_song_id"
    t.index ["user_id"], name: "index_artists_on_user_id"
  end

  create_table "songs", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "artist_name",     null: false
    t.string   "spotify_song_id", null: false
    t.integer  "song_length"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "artist_id"
    t.integer  "user_id"
    t.index ["artist_id"], name: "index_songs_on_artist_id"
    t.index ["user_id"], name: "index_songs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "image_url"
  end

end
