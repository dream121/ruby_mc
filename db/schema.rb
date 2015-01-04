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

ActiveRecord::Schema.define(version: 20141222225528) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "ltree"

  create_table "answers", force: true do |t|
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
    t.integer  "user_id"
    t.string   "thumb_url"
    t.string   "brightcove_id"
  end

  create_table "assignments", force: true do |t|
    t.string   "partial_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "chapter_id"
  end

  create_table "authentications", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.json     "info"
    t.json     "credentials"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cart_products", force: true do |t|
    t.integer  "price"
    t.integer  "qty"
    t.integer  "cart_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cart_products", ["cart_id"], name: "index_cart_products_on_cart_id", using: :btree
  add_index "cart_products", ["product_id"], name: "index_cart_products_on_product_id", using: :btree

  create_table "carts", force: true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "response"
    t.integer  "reminder_count"
    t.integer  "coupon_id"
  end

  add_index "carts", ["coupon_id"], name: "index_carts_on_coupon_id", using: :btree
  add_index "carts", ["course_id"], name: "index_carts_on_course_id", using: :btree
  add_index "carts", ["user_id"], name: "index_carts_on_user_id", using: :btree

  create_table "chapters", force: true do |t|
    t.integer  "number"
    t.string   "duration"
    t.string   "title"
    t.string   "brightcove_id"
    t.integer  "course_id"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "abstract"
    t.text     "video_description"
    t.string   "thumb_url"
    t.integer  "unlock_qty",        default: 0,     null: false
    t.integer  "position"
    t.boolean  "is_bonus",          default: false, null: false
  end

  add_index "chapters", ["course_id"], name: "index_chapters_on_course_id", using: :btree
  add_index "chapters", ["slug"], name: "index_chapters_on_slug", using: :btree

  create_table "coupons", force: true do |t|
    t.string   "code"
    t.integer  "redemptions"
    t.integer  "max_redemptions"
    t.integer  "price"
    t.integer  "course_id"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coupons", ["course_id"], name: "index_coupons_on_course_id", using: :btree

  create_table "course_comments", force: true do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.string   "title"
    t.text     "comment"
    t.integer  "parent_id"
    t.boolean  "hide"
    t.integer  "votes"
    t.json     "voters"
    t.integer  "position"
    t.ltree    "path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible"
    t.integer  "chapter_id"
    t.string   "image_url"
  end

  add_index "course_comments", ["course_id"], name: "index_course_comments_on_course_id", using: :btree
  add_index "course_comments", ["parent_id"], name: "index_course_comments_on_parent_id", using: :btree
  add_index "course_comments", ["path"], name: "index_course_comments_on_path_btree", using: :btree
  add_index "course_comments", ["user_id"], name: "index_course_comments_on_user_id", using: :btree

  create_table "course_details", force: true do |t|
    t.integer  "course_id"
    t.text     "headline"
    t.string   "role"
    t.string   "skill"
    t.text     "overview"
    t.text     "invitation_statement"
    t.text     "lessons_introduction"
    t.text     "instructor_motivation"
    t.text     "welcome_statement"
    t.text     "welcome_back_statement"
    t.string   "total_video_duration"
    t.string   "intro_video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "short_description"
    t.text     "featured_review"
    t.string   "tweet_text"
  end

  add_index "course_details", ["course_id"], name: "index_course_details_on_course_id", using: :btree

  create_table "course_facts", force: true do |t|
    t.integer  "course_id"
    t.string   "kind"
    t.integer  "position"
    t.string   "icon"
    t.string   "number"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_facts", ["course_id"], name: "index_course_facts_on_course_id", using: :btree

  create_table "course_reviews", force: true do |t|
    t.text     "review"
    t.integer  "rating"
    t.string   "name"
    t.string   "location"
    t.integer  "course_id"
    t.integer  "user_id"
    t.boolean  "visible",    default: true
    t.boolean  "featured",   default: false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_reviews", ["course_id"], name: "index_course_reviews_on_course_id", using: :btree
  add_index "course_reviews", ["user_id"], name: "index_course_reviews_on_user_id", using: :btree

  create_table "courses", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.integer  "price"
    t.date     "start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
    t.boolean  "available_now",                                  default: false, null: false
    t.decimal  "review_average_display", precision: 3, scale: 2
    t.integer  "student_count_display"
  end

  add_index "courses", ["slug"], name: "index_courses_on_slug", unique: true, using: :btree

  create_table "courses_instructors", force: true do |t|
    t.integer "course_id"
    t.integer "instructor_id"
  end

  create_table "documents", force: true do |t|
    t.string   "kind"
    t.integer  "documentable_id"
    t.string   "documentable_type"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "url"
  end

  create_table "email_templates", force: true do |t|
    t.string   "from"
    t.string   "subject"
    t.text     "body"
    t.integer  "course_id"
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "email_templates", ["course_id"], name: "index_email_templates_on_course_id", using: :btree

  create_table "experiment_values", force: true do |t|
    t.string   "experiment"
    t.string   "variation"
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "experiment_values", ["experiment", "variation", "key"], name: "index_experiment_values_on_experiment_and_variation_and_key", unique: true, using: :btree

  create_table "home_pages", force: true do |t|
    t.text     "tweet_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "fb_headline"
    t.text     "fb_description"
    t.string   "fb_link"
  end

  create_table "identities", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "authentication_id"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  add_index "identities", ["authentication_id"], name: "index_identities_on_authentication_id", using: :btree
  add_index "identities", ["password_reset_token"], name: "index_identities_on_password_reset_token", using: :btree

  create_table "images", force: true do |t|
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "instructors", force: true do |t|
    t.string   "name"
    t.text     "short_bio"
    t.text     "long_bio"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.text     "testimonials"
    t.integer  "user_id"
    t.text     "pitch_description"
    t.text     "popular_quote"
    t.text     "class_quote"
    t.text     "class_quote_attribution"
    t.text     "office_hours_pitch"
    t.integer  "question_id"
    t.string   "hero_url"
    t.string   "popular_quote_logo_url"
  end

  add_index "instructors", ["slug"], name: "index_instructors_on_slug", unique: true, using: :btree
  add_index "instructors", ["user_id"], name: "index_instructors_on_user_id", using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.boolean  "viewed",          default: false
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_products", force: true do |t|
    t.integer  "price"
    t.integer  "qty"
    t.integer  "order_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_products", ["order_id"], name: "index_order_products_on_order_id", using: :btree
  add_index "order_products", ["product_id"], name: "index_order_products_on_product_id", using: :btree

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "coupon_id"
  end

  add_index "orders", ["coupon_id"], name: "index_orders_on_coupon_id", using: :btree
  add_index "orders", ["course_id"], name: "index_orders_on_course_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "payments", force: true do |t|
    t.integer  "order_id"
    t.string   "transaction_id"
    t.json     "response"
    t.integer  "amount"
    t.boolean  "paid"
    t.boolean  "refunded"
    t.integer  "amount_refunded"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["order_id"], name: "index_payments_on_order_id", using: :btree

  create_table "products", force: true do |t|
    t.string   "name"
    t.integer  "price"
    t.string   "kind"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["course_id"], name: "index_products_on_course_id", using: :btree

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.string   "display_name"
    t.string   "tagline"
    t.string   "city"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: true do |t|
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
    t.string   "text_question"
    t.string   "subject"
    t.boolean  "visibility",         default: false
    t.integer  "user_id"
    t.integer  "answer_id"
    t.integer  "position"
    t.string   "thumb_url"
    t.string   "brightcove_id"
    t.string   "source_url"
    t.string   "question_type"
  end

  create_table "recommendations", force: true do |t|
    t.integer  "position"
    t.integer  "product_id"
    t.integer  "related_product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recommendations", ["product_id"], name: "index_recommendations_on_product_id", using: :btree
  add_index "recommendations", ["related_product_id"], name: "index_recommendations_on_related_product_id", using: :btree

  create_table "reviews", force: true do |t|
    t.text     "course_review"
    t.integer  "rating"
    t.string   "name"
    t.string   "location"
    t.integer  "course_id"
    t.integer  "user_id"
    t.boolean  "visible"
    t.boolean  "featured"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["course_id"], name: "index_reviews_on_course_id", using: :btree
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree

  create_table "tasks", force: true do |t|
    t.json     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.integer  "assignment_id"
  end

  create_table "uploads", force: true do |t|
    t.integer  "uploadable_id"
    t.string   "uploadable_type"
    t.string   "url"
    t.string   "kind"
    t.string   "key"
    t.string   "mimetype"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_courses", force: true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.boolean  "access",     default: true
    t.json     "progress"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_id"
    t.boolean  "welcomed"
  end

  add_index "user_courses", ["course_id"], name: "index_user_courses_on_course_id", using: :btree
  add_index "user_courses", ["order_id"], name: "index_user_courses_on_order_id", using: :btree
  add_index "user_courses", ["user_id"], name: "index_user_courses_on_user_id", using: :btree
  add_index "user_courses", ["welcomed"], name: "index_user_courses_on_welcomed", using: :btree

  create_table "user_task_responses", force: true do |t|
    t.boolean  "is_complete", default: false, null: false
    t.integer  "task_id"
    t.json     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "email"
    t.json     "info"
    t.json     "credentials"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "permissions"
    t.json     "email_settings"
    t.json     "privacy_settings"
    t.json     "address"
    t.string   "profile_photo_url"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "name"
  end

end
