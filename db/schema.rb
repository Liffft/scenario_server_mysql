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

ActiveRecord::Schema.define(version: 20150320224556) do

  create_table "devices", force: :cascade do |t|
    t.string   "device_ip",   limit: 255
    t.integer  "scenario_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "devices", ["scenario_id"], name: "index_devices_on_scenario_id", using: :btree

  create_table "features", force: :cascade do |t|
    t.string   "feature_name", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "flows", force: :cascade do |t|
    t.string   "flow_name",  limit: 255
    t.integer  "feature_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "flows", ["feature_id"], name: "index_flows_on_feature_id", using: :btree

  create_table "routes", force: :cascade do |t|
    t.string   "route_type",   limit: 255
    t.string   "path",         limit: 255
    t.text     "query",        limit: 65535
    t.text     "request_body", limit: 65535
    t.text     "fixture",      limit: 65535
    t.string   "status",       limit: 255
    t.integer  "scenario_id",  limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "routes", ["scenario_id"], name: "index_routes_on_scenario_id", using: :btree

  create_table "scenarios", force: :cascade do |t|
    t.string   "scenario_name", limit: 255
    t.integer  "flow_id",       limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "scenarios", ["flow_id"], name: "index_scenarios_on_flow_id", using: :btree

  add_foreign_key "devices", "scenarios"
  add_foreign_key "flows", "features"
  add_foreign_key "routes", "scenarios"
  add_foreign_key "scenarios", "flows"
end
