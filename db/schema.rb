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

ActiveRecord::Schema.define(version: 20180313063258) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "administrators", force: :cascade do |t|
    t.string   "mobile"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "verification_code"
    t.boolean  "active",                            default: true
    t.boolean  "confirmed",                         default: false
    t.integer  "login_count",                       default: 0,     null: false
    t.integer  "failed_login_count",                default: 0,     null: false
    t.datetime "last_request_at",     precision: 6
    t.datetime "current_login_at",    precision: 6
    t.datetime "last_login_at",       precision: 6
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "nickname"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at",   precision: 6
    t.integer  "role_cd",                           default: 0
    t.datetime "created_at",          precision: 6,                 null: false
    t.datetime "updated_at",          precision: 6,                 null: false
    t.index ["mobile"], name: "index_administrators_on_mobile", unique: true, using: :btree
    t.index ["role_cd"], name: "index_administrators_on_role_cd", using: :btree
  end

  create_table "bids", force: :cascade do |t|
    t.integer  "mechanic_id"
    t.integer  "order_id"
    t.integer  "markup_price",               default: 0
    t.datetime "created_at",   precision: 6,             null: false
    t.datetime "updated_at",   precision: 6,             null: false
    t.index ["mechanic_id"], name: "index_bids_on_mechanic_id", using: :btree
    t.index ["order_id"], name: "index_bids_on_order_id", using: :btree
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
  end

  create_table "cities", force: :cascade do |t|
    t.string  "name"
    t.string  "fullname"
    t.integer "province_id"
    t.integer "lbs_id"
    t.index ["fullname"], name: "index_cities_on_fullname", using: :btree
    t.index ["lbs_id"], name: "index_cities_on_lbs_id", using: :btree
    t.index ["province_id"], name: "index_cities_on_province_id", using: :btree
  end

  create_table "cities_bak", force: :cascade do |t|
    t.string  "name"
    t.integer "province_id"
    t.integer "lbs_id"
    t.string  "fullname"
    t.index ["fullname"], name: "index_cities_bak_on_fullname", using: :btree
    t.index ["lbs_id"], name: "index_cities_bak_on_lbs_id", using: :btree
    t.index ["province_id"], name: "index_cities_bak_on_province_id", using: :btree
  end

  create_table "confirm_orders", force: :cascade do |t|
    t.integer  "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "districts", force: :cascade do |t|
    t.string  "name"
    t.string  "fullname"
    t.integer "city_id"
    t.integer "lbs_id"
    t.index ["city_id"], name: "index_districts_on_city_id", using: :btree
    t.index ["fullname"], name: "index_districts_on_fullname", using: :btree
    t.index ["lbs_id"], name: "index_districts_on_lbs_id", using: :btree
  end

  create_table "districts_bak", force: :cascade do |t|
    t.string  "name"
    t.integer "city_id"
    t.integer "lbs_id"
    t.string  "fullname"
    t.index ["city_id"], name: "index_districts_bak_on_city_id", using: :btree
    t.index ["fullname"], name: "index_districts_bak_on_fullname", using: :btree
    t.index ["lbs_id"], name: "index_districts_bak_on_lbs_id", using: :btree
  end

  create_table "fellowships", force: :cascade do |t|
    t.integer  "mechanic_id"
    t.integer  "user_id"
    t.datetime "created_at",  precision: 6, null: false
    t.datetime "updated_at",  precision: 6, null: false
    t.text     "remark"
    t.index ["mechanic_id"], name: "index_fellowships_on_mechanic_id", using: :btree
    t.index ["user_id"], name: "index_fellowships_on_user_id", using: :btree
  end

  create_table "logs", force: :cascade do |t|
    t.string   "data"
    t.string   "logtype"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mechanics", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "province_cd"
    t.integer  "city_cd"
    t.integer  "district_cd"
    t.text     "description"
    t.datetime "created_at",                     precision: 6,                            null: false
    t.datetime "updated_at",                     precision: 6,                            null: false
    t.float    "professionality_average",                                 default: 4.0
    t.float    "timeliness_average",                                      default: 4.0
    t.decimal  "total_income",                   precision: 10, scale: 2, default: "0.0"
    t.integer  "available_orders_count",                                  default: 0
    t.string   "user_nickname"
    t.string   "user_mobile"
    t.string   "user_address"
    t.integer  "revoke_orders_count",                                     default: 0
    t.string   "user_weixin_openid"
    t.string   "unique_id"
    t.string   "linkman"
    t.string   "mechanic_attach_1_file_name"
    t.string   "mechanic_attach_1_content_type"
    t.integer  "mechanic_attach_1_file_size"
    t.datetime "mechanic_attach_1_updated_at"
    t.string   "mechanic_attach_2_file_name"
    t.string   "mechanic_attach_2_content_type"
    t.integer  "mechanic_attach_2_file_size"
    t.datetime "mechanic_attach_2_updated_at"
    t.string   "mechanic_attach_3_file_name"
    t.string   "mechanic_attach_3_content_type"
    t.integer  "mechanic_attach_3_file_size"
    t.datetime "mechanic_attach_3_updated_at"
    t.string   "mechanic_attach_4_file_name"
    t.string   "mechanic_attach_4_content_type"
    t.integer  "mechanic_attach_4_file_size"
    t.datetime "mechanic_attach_4_updated_at"
    t.string   "mechanic_attach_5_file_name"
    t.string   "mechanic_attach_5_content_type"
    t.integer  "mechanic_attach_5_file_size"
    t.datetime "mechanic_attach_5_updated_at"
    t.integer  "last_available_orders_count"
    t.integer  "last_done_orders_count"
    t.decimal  "done_orders_count_rate",         precision: 10, scale: 2
    t.string   "service_staff"
    t.integer  "grade_cd"
    t.datetime "holiday_start"
    t.datetime "holiday_end"
    t.string   "group_id"
    t.index ["city_cd"], name: "index_mechanics_on_city_cd", using: :btree
    t.index ["district_cd"], name: "index_mechanics_on_district_cd", using: :btree
    t.index ["province_cd"], name: "index_mechanics_on_province_cd", using: :btree
    t.index ["user_id"], name: "index_mechanics_on_user_id", using: :btree
  end

  create_table "mechanics_services", id: false, force: :cascade do |t|
    t.integer "mechanic_id", null: false
    t.integer "service_id",  null: false
  end

  create_table "mechanics_skills", id: false, force: :cascade do |t|
    t.integer "mechanic_id", null: false
    t.integer "skill_id",    null: false
    t.integer "price"
  end

  create_table "merchants", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "mobile"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "verification_code"
    t.boolean  "confirmed",                         default: false
    t.string   "nickname"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at",   precision: 6
    t.integer  "role_cd",                           default: 0
    t.datetime "created_at",          precision: 6,                 null: false
    t.datetime "updated_at",          precision: 6,                 null: false
    t.boolean  "active",                            default: true
    t.integer  "login_count",                       default: 0,     null: false
    t.integer  "failed_login_count",                default: 0,     null: false
    t.datetime "last_request_at",     precision: 6
    t.datetime "current_login_at",    precision: 6
    t.datetime "last_login_at",       precision: 6
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "store_nickname"
    t.string   "store_mobile"
    t.string   "store_address"
    t.string   "store_hotline"
    t.index ["mobile"], name: "index_merchants_on_mobile", unique: true, using: :btree
    t.index ["role_cd"], name: "index_merchants_on_role_cd", using: :btree
    t.index ["user_id"], name: "index_merchants_on_user_id", using: :btree
  end

  create_table "metrics", force: :cascade do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "user_id"
    t.string   "method"
    t.text     "data"
    t.datetime "created_at",  precision: 6
    t.datetime "updated_at",  precision: 6
    t.index ["source_type", "source_id"], name: "index_metrics_on_source_type_and_source_id", using: :btree
    t.index ["user_id"], name: "index_metrics_on_user_id", using: :btree
  end

  create_table "notes", force: :cascade do |t|
    t.integer  "store_id"
    t.text     "content"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["store_id"], name: "index_notes_on_store_id", using: :btree
  end

  create_table "numbers", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "jdorder_id"
    t.string   "pwd_number"
    t.string   "pwd_number_default"
    t.string   "shop_id"
    t.string   "shop_name"
    t.integer  "status",             default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "number_type_cd",     default: 0
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "mechanic_id"
    t.integer  "merchant_id"
    t.string   "address"
    t.datetime "appointment",                    precision: 6
    t.integer  "skill_cd"
    t.integer  "brand_cd"
    t.integer  "series_cd"
    t.integer  "quoted_price"
    t.text     "remark"
    t.integer  "professionality",                              default: 4
    t.integer  "timeliness",                                   default: 4
    t.text     "review"
    t.integer  "state_cd",                                     default: 0
    t.integer  "mechanic_sent_count",                          default: 0
    t.integer  "bid_id"
    t.integer  "lbs_id"
    t.string   "mechanic_attach_1_file_name"
    t.string   "mechanic_attach_1_content_type"
    t.integer  "mechanic_attach_1_file_size"
    t.datetime "mechanic_attach_1_updated_at",   precision: 6
    t.string   "mechanic_attach_2_file_name"
    t.string   "mechanic_attach_2_content_type"
    t.integer  "mechanic_attach_2_file_size"
    t.datetime "mechanic_attach_2_updated_at",   precision: 6
    t.string   "user_attach_1_file_name"
    t.string   "user_attach_1_content_type"
    t.integer  "user_attach_1_file_size"
    t.datetime "user_attach_1_updated_at",       precision: 6
    t.string   "user_attach_2_file_name"
    t.string   "user_attach_2_content_type"
    t.integer  "user_attach_2_file_size"
    t.datetime "user_attach_2_updated_at",       precision: 6
    t.string   "contact_nickname"
    t.string   "contact_mobile"
    t.integer  "cancel_cd",                                    default: 0
    t.datetime "start_working_at",               precision: 6
    t.datetime "created_at",                     precision: 6,                 null: false
    t.datetime "updated_at",                     precision: 6,                 null: false
    t.integer  "markup_price",                                 default: 0
    t.integer  "pay_type_cd",                                  default: 0
    t.datetime "paid_at",                        precision: 6
    t.datetime "refunded_at",                    precision: 6
    t.string   "trade_no"
    t.integer  "refund_cd",                                    default: 0
    t.integer  "province_cd"
    t.integer  "city_cd"
    t.string   "user_nickname"
    t.string   "user_mobile"
    t.string   "mechanic_nickname"
    t.string   "mechanic_mobile"
    t.string   "merchant_nickname"
    t.string   "merchant_mobile"
    t.datetime "reviewed_at",                    precision: 6
    t.datetime "finish_working_at",              precision: 6
    t.text     "merchant_remark"
    t.datetime "closed_at",                      precision: 6
    t.boolean  "hosting",                                      default: false
    t.integer  "procedure_price",                              default: 0
    t.boolean  "appointing",                                   default: false
    t.string   "store_nickname"
    t.string   "store_hotline"
    t.float    "lat"
    t.float    "lng"
    t.boolean  "offline"
    t.datetime "refund_at",                      precision: 6
    t.text     "hosting_remark"
    t.integer  "selectmechanic_id"
    t.integer  "quantity"
    t.boolean  "emergency",                                    default: false
    t.integer  "confirm_type_cd",                              default: 0
    t.boolean  "automatic",                                    default: false
    t.string   "ordersign"
    t.integer  "confirm_by"
    t.boolean  "partcheck_order"
    t.integer  "repick_by"
    t.string   "repick_by_merchant_name"
    t.boolean  "automatic_confirm",                            default: false
    t.string   "confirm_by_merchant_name"
    t.boolean  "automatic_confirm_check",                      default: false
    t.boolean  "automatic_repick_check",                       default: false
    t.string   "jd_order_id"
    t.string   "jd_shop_id"
    t.integer  "jd_order_type_cd"
    t.index ["bid_id"], name: "index_orders_on_bid_id", using: :btree
    t.index ["cancel_cd"], name: "index_orders_on_cancel_cd", using: :btree
    t.index ["hosting"], name: "index_orders_on_hosting", using: :btree
    t.index ["mechanic_id"], name: "index_orders_on_mechanic_id", using: :btree
    t.index ["merchant_id"], name: "index_orders_on_merchant_id", using: :btree
    t.index ["pay_type_cd"], name: "index_orders_on_pay_type_cd", using: :btree
    t.index ["refund_cd"], name: "index_orders_on_refund_cd", using: :btree
    t.index ["state_cd"], name: "index_orders_on_state_cd", using: :btree
    t.index ["user_id"], name: "index_orders_on_user_id", using: :btree
  end

  create_table "partchecks", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "quoted_price"
    t.integer  "quantity"
    t.integer  "mechanic_income"
    t.integer  "procedure_price"
    t.integer  "confirm_by"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "remark"
    t.integer  "confirm_type_cd", default: 0
  end

  create_table "products", force: :cascade do |t|
    t.integer  "merchant_id"
    t.integer  "skill_id"
    t.integer  "price"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "provinces", force: :cascade do |t|
    t.string  "name"
    t.string  "fullname"
    t.integer "lbs_id"
    t.index ["fullname"], name: "index_provinces_on_fullname", using: :btree
    t.index ["lbs_id"], name: "index_provinces_on_lbs_id", using: :btree
  end

  create_table "provinces_bak", force: :cascade do |t|
    t.string  "name"
    t.integer "lbs_id"
    t.string  "fullname"
    t.index ["fullname"], name: "index_provinces_bak_on_fullname", using: :btree
    t.index ["lbs_id"], name: "index_provinces_bak_on_lbs_id", using: :btree
  end

  create_table "recharges", force: :cascade do |t|
    t.integer  "merchant_id"
    t.integer  "store_id"
    t.integer  "amount"
    t.integer  "state_cd",                  default: 0
    t.integer  "pay_type_cd",               default: 0
    t.string   "trade_no"
    t.datetime "paid_at",     precision: 6
    t.datetime "created_at",  precision: 6,             null: false
    t.datetime "updated_at",  precision: 6,             null: false
    t.index ["merchant_id"], name: "index_recharges_on_merchant_id", using: :btree
    t.index ["pay_type_cd"], name: "index_recharges_on_pay_type_cd", using: :btree
    t.index ["state_cd"], name: "index_recharges_on_state_cd", using: :btree
    t.index ["store_id"], name: "index_recharges_on_store_id", using: :btree
  end

  create_table "series", force: :cascade do |t|
    t.string  "name"
    t.integer "brand_id"
    t.index ["brand_id"], name: "index_series_on_brand_id", using: :btree
  end

  create_table "services", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string   "var",                                 null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at",            precision: 6
    t.datetime "updated_at",            precision: 6
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.string "group_id"
  end

  create_table "temp_mechanic_jd_parts", force: :cascade do |t|
    t.string   "mechanic_num"
    t.string   "name"
    t.string   "unique_id"
    t.string   "group_id"
    t.integer  "mechanic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temp_mechanics", force: :cascade do |t|
    t.integer  "mechanic_id"
    t.string   "mechanicname"
    t.string   "addr"
    t.string   "tel"
    t.integer  "lbs_id"
    t.string   "description"
    t.datetime "created_at",   default: -> { "now()" }, null: false
    t.datetime "updated_at",   default: -> { "now()" }, null: false
  end

  create_table "temp_mechanics_copy", id: :integer, default: -> { "nextval('temp_mechanics_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer  "mechanic_id"
    t.string   "mechanicname"
    t.string   "addr"
    t.string   "tel"
    t.integer  "lbs_id"
    t.string   "description"
    t.datetime "created_at",   precision: 6, default: -> { "now()" }, null: false
    t.datetime "updated_at",   precision: 6, default: -> { "now()" }, null: false
  end

  create_table "temp_mechanics_copy1", id: :integer, default: -> { "nextval('temp_mechanics_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer  "mechanic_id"
    t.string   "mechanicname"
    t.string   "addr"
    t.string   "tel"
    t.integer  "lbs_id"
    t.string   "description"
    t.datetime "created_at",   precision: 6, default: -> { "now()" }, null: false
    t.datetime "updated_at",   precision: 6, default: -> { "now()" }, null: false
  end

  create_table "temp_mechanics_getweb", force: :cascade do |t|
    t.string "locshopname", limit: 500
    t.string "province",    limit: 50
    t.string "city",        limit: 50
    t.string "district",    limit: 50
    t.string "locshopaddr", limit: 500
    t.string "phone",       limit: 50
    t.string "bai_tel",     limit: 500
  end

  create_table "temp_mechanics_jd", id: false, force: :cascade do |t|
    t.string "门店编号",      limit: 255
    t.string "门店名称*",     limit: 255
    t.string "门店一级地址*",   limit: 255
    t.string "门店二级地址*",   limit: 255
    t.string "门店三级地址*",   limit: 255
    t.string "详细地址*",     limit: 255
    t.string "门店联系电话",    limit: 255
    t.string "门店坐标",      limit: 255
    t.string "门店组id",     limit: 255
    t.string "统一信用机构代码",  limit: 255
    t.string "营业执照号",     limit: 255
    t.string "门店负责人姓名",   limit: 255
    t.string "门店负责人身份证号", limit: 255
    t.string "营业开始时间*",   limit: 255
    t.string "营业结束时间*",   limit: 255
    t.string "暂停开始日期",    limit: 255
    t.string "暂停结束日期",    limit: 255
    t.string "门店状态*",     limit: 255
    t.string "客服座机",      limit: 255
    t.string "客服400电话",   limit: 255
    t.string "是否支持发货到店*", limit: 255
    t.string "商家id*",     limit: 255
    t.string "门店类型",      limit: 255
    t.string "是否京东认证",    limit: 255
    t.string "是否删除该门店",   limit: 255
    t.string "5周年",       limit: 255
  end

  create_table "temp_mechanics_jd5", id: false, force: :cascade do |t|
    t.string "名称", limit: 255
    t.string "电话", limit: 255
    t.string "店名", limit: 255
    t.string "地址", limit: 255
    t.string "匹配", limit: 255
  end

  create_table "user_groups", force: :cascade do |t|
    t.string   "nickname"
    t.text     "description"
    t.boolean  "confirmed",                                      default: false
    t.integer  "user_id"
    t.string   "weixin_qr_code_ticket"
    t.datetime "created_at",            precision: 6,                            null: false
    t.datetime "updated_at",            precision: 6,                            null: false
    t.decimal  "total_commission",      precision: 10, scale: 2, default: "0.0"
    t.integer  "settled_orders_count",                           default: 0
    t.integer  "users_count",                                    default: 0
    t.index ["user_id"], name: "index_user_groups_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "mobile"
    t.string   "persistence_token"
    t.string   "verification_code"
    t.boolean  "active",                                          default: true
    t.boolean  "confirmed",                                       default: false
    t.string   "weixin_openid"
    t.string   "nickname"
    t.integer  "gender_cd"
    t.string   "address"
    t.string   "qq"
    t.float    "balance",                                         default: 0.0
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at",      precision: 6
    t.integer  "role_cd",                                         default: 0
    t.integer  "user_group_id"
    t.datetime "created_at",             precision: 6,                            null: false
    t.datetime "updated_at",             precision: 6,                            null: false
    t.integer  "login_count",                                     default: 0,     null: false
    t.integer  "failed_login_count",                              default: 0,     null: false
    t.datetime "last_request_at",        precision: 6
    t.datetime "current_login_at",       precision: 6
    t.datetime "last_login_at",          precision: 6
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.decimal  "total_cost",             precision: 10, scale: 2, default: "0.0"
    t.integer  "available_orders_count",                          default: 0
    t.boolean  "host",                                            default: false
    t.boolean  "hidden",                                          default: false
    t.string   "hotline"
    t.float    "lat"
    t.float    "lng"
    t.string   "fromsource"
    t.boolean  "userupdate",                                      default: false
    t.boolean  "systempay",                                       default: false
    t.string   "withdrawal_remark"
    t.string   "venderid"
    t.index ["host"], name: "index_users_on_host", using: :btree
    t.index ["mobile"], name: "index_users_on_mobile", unique: true, using: :btree
    t.index ["role_cd"], name: "index_users_on_role_cd", using: :btree
    t.index ["user_group_id"], name: "index_users_on_user_group_id", using: :btree
  end

  create_table "withdrawals", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "amount"
    t.integer  "state_cd",                  default: 0
    t.datetime "created_at",  precision: 6,             null: false
    t.datetime "updated_at",  precision: 6,             null: false
    t.datetime "paid_at",     precision: 6
    t.integer  "pay_type_cd",               default: 0
    t.index ["state_cd"], name: "index_withdrawals_on_state_cd", using: :btree
    t.index ["user_id"], name: "index_withdrawals_on_user_id", using: :btree
  end

  create_table "works", force: :cascade do |t|
    t.integer  "mechanic_id"
    t.integer  "skill_id"
    t.integer  "price"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
