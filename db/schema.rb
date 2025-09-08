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

ActiveRecord::Schema[8.0].define(version: 2025_08_20_100312) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "assessments", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.string "email"
    t.string "phone_country_code"
    t.string "phone_number"
    t.boolean "privacy_consent", default: false
    t.boolean "marketing_consent", default: false
    t.text "notes"
    t.string "session_token", null: false
    t.integer "current_step", default: 1
    t.integer "standing_spinal_flexion_test"
    t.integer "arms_overhead"
    t.integer "spine_rotation_right"
    t.integer "spine_rotation_left"
    t.integer "deep_squat"
    t.integer "hands_behind_back_right"
    t.integer "hands_behind_back_left"
    t.integer "straight_leg_raise_right"
    t.integer "straight_leg_raise_left"
    t.boolean "completed", default: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["completed"], name: "index_assessments_on_completed"
    t.index ["created_at"], name: "index_assessments_on_created_at"
    t.index ["email"], name: "index_assessments_on_email"
    t.index ["phone_country_code"], name: "index_assessments_on_phone_country_code"
    t.index ["session_token"], name: "index_assessments_on_session_token", unique: true
  end
end
