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

ActiveRecord::Schema[7.0].define(version: 2023_01_07_064100) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "assessments", force: :cascade do |t|
    t.bigint "instrument_id", null: false
    t.bigint "unit_id", null: false
    t.float "unit_weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["instrument_id"], name: "index_assessments_on_instrument_id"
    t.index ["unit_id"], name: "index_assessments_on_unit_id"
  end

  create_table "chatrooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cohorts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "start_date"
    t.date "end_date"
  end

  create_table "courses", force: :cascade do |t|
    t.bigint "cohort_id", null: false
    t.bigint "syllabus_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cohort_id"], name: "index_courses_on_cohort_id"
    t.index ["syllabus_id"], name: "index_courses_on_syllabus_id"
  end

  create_table "grades", force: :cascade do |t|
    t.bigint "assessment_id", null: false
    t.bigint "student_id", null: false
    t.float "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_id"], name: "index_grades_on_assessment_id"
    t.index ["student_id"], name: "index_grades_on_student_id"
  end

  create_table "instruments", force: :cascade do |t|
    t.date "date"
    t.string "title"
    t.bigint "subject_id", null: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_instruments_on_subject_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "chatroom_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chatroom_id"], name: "index_messages_on_chatroom_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "participants", force: :cascade do |t|
    t.bigint "chatroom_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chatroom_id"], name: "index_participants_on_chatroom_id"
    t.index ["user_id"], name: "index_participants_on_user_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.bigint "discipline_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discipline_id"], name: "index_subjects_on_discipline_id"
  end

  create_table "syllabuses", force: :cascade do |t|
    t.string "name"
    t.bigint "teacher_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "subject_id", null: false
    t.index ["subject_id"], name: "index_syllabuses_on_subject_id"
    t.index ["teacher_id"], name: "index_syllabuses_on_teacher_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "name"
    t.bigint "syllabus_id", null: false
    t.float "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["syllabus_id"], name: "index_units_on_syllabus_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "role", default: 1
    t.bigint "parent_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["parent_id"], name: "index_users_on_parent_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assessments", "instruments"
  add_foreign_key "assessments", "units"
  add_foreign_key "courses", "cohorts"
  add_foreign_key "courses", "syllabuses"
  add_foreign_key "grades", "assessments"
  add_foreign_key "grades", "users", column: "student_id"
  add_foreign_key "instruments", "subjects"
  add_foreign_key "messages", "chatrooms"
  add_foreign_key "messages", "users"
  add_foreign_key "participants", "chatrooms"
  add_foreign_key "participants", "users"
  add_foreign_key "subjects", "subjects", column: "discipline_id"
  add_foreign_key "syllabuses", "subjects"
  add_foreign_key "syllabuses", "users", column: "teacher_id"
  add_foreign_key "units", "syllabuses"
  add_foreign_key "users", "users", column: "parent_id"
end
