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

ActiveRecord::Schema.define(version: 20161213220142) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "plans", force: :cascade do |t|
    t.string   "status"
    t.date     "decision_date"
    t.string   "description"
    t.geometry "location",          limit: {:srid=>0, :type=>"point"}
    t.string   "more_info_link"
    t.string   "reference"
    t.date     "registration_date"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

end