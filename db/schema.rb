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

ActiveRecord::Schema.define(version: 20140722092430) do

  create_table "addresses", force: true do |t|
    t.string   "depth1"
    t.string   "depth2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_cplock_advertisements", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "advertise_cpd_logs", force: true do |t|
    t.integer  "ad_id"
    t.integer  "ad_type"
    t.integer  "user_id"
    t.integer  "act"
    t.string   "facebook_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "advertise_cpdm_logs", force: true do |t|
    t.integer  "ad_id"
    t.integer  "ad_type",     default: 201
    t.integer  "user_id"
    t.integer  "act"
    t.integer  "view_time"
    t.string   "facebook_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "advertise_cpx_logs", force: true do |t|
    t.integer  "ad_id"
    t.integer  "ad_type"
    t.integer  "user_id"
    t.integer  "act"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "advertise_lock_logs", force: true do |t|
    t.integer  "ad_id"
    t.integer  "group"
    t.integer  "ad_type"
    t.integer  "user_id"
    t.integer  "act"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_info_pros", force: true do |t|
    t.string   "android_version"
    t.string   "android_package_name"
    t.string   "market_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_infos", force: true do |t|
    t.string   "time_quick_ans"
    t.string   "one_medal"
    t.string   "two_medal"
    t.string   "test_reward_max"
    t.string   "android_version"
    t.string   "ios_version"
    t.string   "app_server"
    t.integer  "popup_style"
    t.string   "popup_image"
    t.text     "popup_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "new_stage_day_limit"
    t.string   "android_package_name"
    t.string   "ios_package_name"
    t.string   "market_url"
    t.string   "appstore_url"
    t.integer  "voice_ver"
    t.string   "pin_dtm"
    t.integer  "store_open",           default: 0
  end

  create_table "app_introduce_videos", force: true do |t|
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "video"
  end

  create_table "bank_lists", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "board_help_pros", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "board_helps", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "board_notice_pros", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "board_notices", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cacao_ments", force: true do |t|
    t.string   "ment"
    t.string   "btn_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", force: true do |t|
    t.string   "cor_name"
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "mobile"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupon_free_infos", force: true do |t|
    t.string   "name"
    t.string   "place"
    t.date     "valid_start"
    t.date     "valid_end"
    t.string   "bar_code"
    t.string   "image"
    t.text     "information"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cpd_advertisements", force: true do |t|
    t.string   "ad_name"
    t.integer  "cli_id"
    t.integer  "ad_type"
    t.integer  "contract"
    t.integer  "remain"
    t.integer  "basic_show_price", default: 0
    t.integer  "action_price",     default: 0
    t.integer  "pay_type",         default: 1
    t.date     "start_date"
    t.date     "end_date"
    t.string   "front_image"
    t.string   "back_image"
    t.integer  "coupon_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "priority",         default: 4
    t.integer  "reward"
    t.integer  "point"
    t.string   "name"
    t.string   "caption"
    t.string   "description"
    t.string   "link"
    t.string   "picture"
    t.integer  "target",           default: 0
  end

  create_table "cpdm_advertisements", force: true do |t|
    t.string   "ad_name"
    t.integer  "cli_id"
    t.integer  "ad_type",                default: 201
    t.integer  "contract"
    t.integer  "remain"
    t.integer  "basic_show_price",       default: 0
    t.integer  "pay_type",               default: 1
    t.date     "start_date"
    t.date     "end_date"
    t.string   "url"
    t.string   "length"
    t.integer  "priority",               default: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "video"
    t.integer  "full_show_price",        default: 0
    t.integer  "additional_share_price", default: 0
    t.integer  "reward"
    t.integer  "point"
    t.string   "name"
    t.string   "caption"
    t.string   "description"
    t.string   "link"
    t.string   "picture"
    t.integer  "video_ver",              default: 0
    t.integer  "target",                 default: 0
  end

  create_table "cpx_advertisements", force: true do |t|
    t.string   "ad_name"
    t.integer  "cli_id"
    t.integer  "ad_type"
    t.integer  "contract"
    t.integer  "remain"
    t.integer  "basic_show_price", default: 0
    t.integer  "pay_type",         default: 1
    t.date     "start_date"
    t.date     "end_date"
    t.string   "ad_image"
    t.string   "ad_text"
    t.string   "target_url"
    t.string   "package_name"
    t.string   "confirm_url"
    t.integer  "reward"
    t.integer  "point"
    t.integer  "n_question"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "priority",         default: 5
    t.integer  "target",           default: 0
  end

  create_table "create_user_stage_infos", force: true do |t|
    t.integer  "user_id"
    t.string   "stage_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exam_words", force: true do |t|
    t.integer  "exam_no"
    t.string   "title"
    t.integer  "part"
    t.string   "word"
    t.string   "mean"
    t.string   "q_no"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exam_words_logs", force: true do |t|
    t.integer  "exam_no"
    t.integer  "part"
    t.integer  "user_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inactive_users", force: true do |t|
    t.string   "email"
    t.string   "facebook"
    t.string   "password_digest"
    t.string   "nickname"
    t.string   "recommend"
    t.integer  "sex"
    t.date     "birth"
    t.string   "address"
    t.string   "mobile"
    t.integer  "interest"
    t.integer  "level_test"
    t.integer  "is_set_facebook_password"
    t.integer  "daily_test_count"
    t.integer  "current_reward"
    t.integer  "total_reward"
    t.integer  "is_admin"
    t.datetime "last_test"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "screen_lock"
    t.string   "region"
    t.string   "device"
    t.string   "android_ver"
    t.string   "operator"
    t.string   "device_id"
  end

  create_table "lock_advertisements", force: true do |t|
    t.string   "ad_name"
    t.integer  "link",             default: 0
    t.integer  "linked_id"
    t.integer  "cli_id",           default: 1
    t.integer  "group"
    t.integer  "ad_type"
    t.integer  "contract",         default: 0
    t.integer  "remain",           default: 0
    t.integer  "basic_show_price", default: 0
    t.integer  "action_price",     default: 0
    t.integer  "reward",           default: 0
    t.integer  "point",            default: 0
    t.integer  "pay_type",         default: 1
    t.string   "target_url"
    t.string   "ad_image"
    t.string   "reserve_image"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "priority",         default: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_crosswalks", force: true do |t|
    t.integer  "uid"
    t.integer  "campaign_idx"
    t.string   "campaign_title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_sign_ups", force: true do |t|
    t.text     "invalue"
    t.boolean  "status"
    t.string   "msg"
    t.text     "elog"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ment_lists", force: true do |t|
    t.string   "kind"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "my_coupons", force: true do |t|
    t.integer  "user_id"
    t.integer  "coupon_type"
    t.integer  "coupon_id"
    t.integer  "availability", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.string   "order_id"
    t.string   "barcode"
    t.string   "product_id"
    t.string   "approval_number"
    t.boolean  "is_used",         default: false
    t.date     "limit_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "coupon_company"
    t.string   "issue_date"
    t.boolean  "is_expired",      default: false
    t.boolean  "is_canceled",     default: false
  end

  create_table "point_logs", force: true do |t|
    t.integer  "user_id"
    t.integer  "point_type"
    t.string   "name"
    t.integer  "point"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prizes", force: true do |t|
    t.string   "name"
    t.integer  "category"
    t.integer  "period"
    t.integer  "rank"
    t.date     "date_start"
    t.date     "date_end"
    t.string   "image"
    t.text     "content1"
    t.text     "content2"
    t.text     "content3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "qpcon_categories", force: true do |t|
    t.string   "category_id"
    t.string   "category_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "qpcon_products", force: true do |t|
    t.string   "product_id"
    t.string   "qpcon_category_id"
    t.string   "product_name"
    t.string   "change_market_name"
    t.integer  "stock_count"
    t.integer  "market_cost"
    t.integer  "common_cost"
    t.string   "img_url_70"
    t.string   "img_url_150"
    t.string   "img_url_250"
    t.string   "market_name"
    t.integer  "min_age"
    t.text     "use_info"
    t.integer  "valid_type"
    t.string   "valid_date"
    t.integer  "max_sale_cnt"
    t.integer  "min_sale_cnt"
    t.integer  "mon_max_sale_cnt"
    t.integer  "sale_gb"
    t.integer  "pin_type"
    t.integer  "prod_gb"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reg_dtm"
  end

  create_table "ranking_currents", force: true do |t|
    t.integer  "week_1",     default: 0
    t.integer  "week_2",     default: 0
    t.integer  "week_3",     default: 0
    t.integer  "week_4",     default: 0
    t.date     "week_start", default: '2013-10-28'
    t.date     "week_end",   default: '2013-11-03'
    t.integer  "mon_1",      default: 0
    t.integer  "mon_2",      default: 0
    t.integer  "mon_3",      default: 0
    t.integer  "mon_4",      default: 0
    t.date     "mon_start",  default: '2013-10-01'
    t.date     "mon_end",    default: '2013-10-31'
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ranking_histories", force: true do |t|
    t.string   "rank_type"
    t.date     "start"
    t.date     "end"
    t.integer  "rank"
    t.string   "user_id"
    t.integer  "point"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ranking_temp_mon_as", force: true do |t|
    t.integer  "user_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ranking_temp_mon_as", ["score"], name: "index_ranking_temp_mon_as_on_score", using: :btree

  create_table "ranking_temp_mon_bs", force: true do |t|
    t.integer  "user_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ranking_temp_mon_bs", ["score"], name: "index_ranking_temp_mon_bs_on_score", using: :btree

  create_table "ranking_temp_mon_cs", force: true do |t|
    t.integer  "user_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ranking_temp_mon_cs", ["score"], name: "index_ranking_temp_mon_cs_on_score", using: :btree

  create_table "ranking_temp_mon_ds", force: true do |t|
    t.integer  "user_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ranking_temp_mon_ds", ["score"], name: "index_ranking_temp_mon_ds_on_score", using: :btree

  create_table "ranking_temp_week_as", force: true do |t|
    t.integer  "user_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ranking_temp_week_as", ["score"], name: "index_ranking_temp_week_as_on_score", using: :btree

  create_table "ranking_temp_week_bs", force: true do |t|
    t.integer  "user_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ranking_temp_week_bs", ["score"], name: "index_ranking_temp_week_bs_on_score", using: :btree

  create_table "ranking_temp_week_cs", force: true do |t|
    t.integer  "user_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ranking_temp_week_cs", ["score"], name: "index_ranking_temp_week_cs_on_score", using: :btree

  create_table "ranking_temp_week_ds", force: true do |t|
    t.integer  "user_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ranking_temp_week_ds", ["score"], name: "index_ranking_temp_week_ds_on_score", using: :btree

  create_table "refund_requests", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "bank"
    t.string   "account"
    t.integer  "amount"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reward_logs", force: true do |t|
    t.integer  "user_id"
    t.integer  "reward_type"
    t.string   "title"
    t.string   "sub_title"
    t.integer  "reward"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "survey_contents", force: true do |t|
    t.integer  "ad_id"
    t.integer  "q_no"
    t.integer  "q_type"
    t.string   "q_text"
    t.string   "q_image"
    t.integer  "n_answer"
    t.string   "a1"
    t.string   "a2"
    t.string   "a3"
    t.string   "a4"
    t.string   "a5"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "survey_results", force: true do |t|
    t.integer  "ad_id"
    t.integer  "user_id"
    t.string   "answers"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temp_min", force: true do |t|
    t.string "english"
    t.string "koean"
  end

  create_table "test_words", id: false, force: true do |t|
    t.string "name"
    t.string "mean"
  end

  create_table "user_highest_levels", force: true do |t|
    t.integer  "user_id"
    t.integer  "category"
    t.integer  "stage"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_stage_bests", force: true do |t|
    t.integer  "user_id"
    t.integer  "level"
    t.integer  "stage"
    t.integer  "n_medals_best"
    t.integer  "score_best"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_stage_infos", force: true do |t|
    t.integer  "user_id"
    t.text     "stage_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_test_histories", force: true do |t|
    t.integer  "user_id"
    t.integer  "category"
    t.integer  "level"
    t.integer  "stage"
    t.integer  "n_medals"
    t.integer  "score"
    t.integer  "reward"
    t.integer  "rank_point"
    t.integer  "test_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "facebook"
    t.string   "password_digest",                        null: false
    t.string   "nickname",                               null: false
    t.string   "recommend"
    t.integer  "sex"
    t.date     "birth"
    t.string   "address"
    t.string   "f_address"
    t.string   "mobile",                                 null: false
    t.integer  "interest"
    t.string   "character",                default: "8"
    t.integer  "level_test",               default: 0
    t.integer  "is_set_facebook_password", default: 0
    t.integer  "daily_test_count",         default: 0
    t.integer  "daily_test_reward",        default: 0
    t.integer  "current_reward",           default: 0
    t.integer  "total_reward",             default: 0
    t.integer  "is_admin",                 default: 0
    t.datetime "last_test"
    t.boolean  "screen_lock"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "region"
    t.string   "device"
    t.string   "android_ver"
    t.string   "operator"
    t.string   "device_id"
  end

  create_table "weekly_challenge_logs", force: true do |t|
    t.integer  "user_id"
    t.string   "combo"
    t.integer  "result"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "word_levels", force: true do |t|
    t.integer  "level",      null: false
    t.integer  "stage",      null: false
    t.integer  "index",      null: false
    t.integer  "word_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "word_sounds", force: true do |t|
    t.integer  "word_id"
    t.binary   "sound"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "words", force: true do |t|
    t.string   "name",                   null: false
    t.string   "mean",                   null: false
    t.text     "example_en"
    t.text     "example_ko"
    t.string   "phonetics"
    t.integer  "picture",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.integer  "confirm",    default: 0
    t.integer  "voice"
  end

end
