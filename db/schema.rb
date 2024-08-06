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

ActiveRecord::Schema[7.0].define(version: 2024_08_06_231449) do
  create_table "addresses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "issuer_id", null: false
    t.bigint "country_id", null: false
    t.bigint "province_id", null: false
    t.string "city", null: false
    t.string "address", null: false
    t.string "zip_code", null: false
    t.integer "address_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_addresses_on_country_id"
    t.index ["issuer_id"], name: "index_addresses_on_issuer_id"
    t.index ["province_id"], name: "index_addresses_on_province_id"
  end

  create_table "company_links", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "issuer_id", null: false
    t.string "linkedin_url"
    t.string "youtube_url"
    t.string "instagram_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issuer_id"], name: "index_company_links_on_issuer_id"
  end

  create_table "countries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "edit_request_details", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "edit_request_id", null: false
    t.integer "field_name", default: 0, null: false
    t.string "old_value"
    t.string "new_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["edit_request_id"], name: "index_edit_request_details_on_edit_request_id"
  end

  create_table "edit_requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "issuer_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issuer_id"], name: "index_edit_requests_on_issuer_id"
  end

  create_table "industries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "issuers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "external_id", null: false
    t.string "name_en", null: false
    t.string "name_fr", null: false
    t.text "description_en"
    t.text "description_fr"
    t.string "logo_url"
    t.bigint "industry_id", null: false
    t.date "financial_year_end", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["industry_id"], name: "index_issuers_on_industry_id"
  end

  create_table "provinces", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "security_details", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "issuer_id", null: false
    t.string "name_en", null: false
    t.string "name_fr", null: false
    t.integer "issue_outstanding", default: 0, null: false
    t.integer "reserved_for_issuance", default: 0, null: false
    t.integer "total_equity_shares_as_if_converted", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issuer_id"], name: "index_security_details_on_issuer_id"
  end

  add_foreign_key "addresses", "countries"
  add_foreign_key "addresses", "issuers"
  add_foreign_key "addresses", "provinces"
  add_foreign_key "company_links", "issuers"
  add_foreign_key "edit_request_details", "edit_requests"
  add_foreign_key "edit_requests", "issuers"
  add_foreign_key "issuers", "industries"
  add_foreign_key "security_details", "issuers"
end
