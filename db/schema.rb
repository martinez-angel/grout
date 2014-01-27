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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131115181312) do

  create_table "api_keys", :force => true do |t|
    t.string   "access_token"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "brands", :force => true do |t|
    t.string   "brand_name"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "brand_user_name"
    t.string   "brand_industry"
    t.string   "fan_size_threshold"
    t.boolean  "brand_status",       :default => true
  end

  create_table "page_level_metrics", :force => true do |t|
    t.string   "page_size"
    t.string   "page_pta"
    t.integer  "brand_id"
    t.datetime "page_level_date"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.string   "brand_name"
    t.string   "twenty_eight_day_reach_of_page_posts_organic"
    t.string   "twenty_eight_day_reach_of_page_posts_viral"
    t.string   "twenty_eight_day_total_impressions_of_page_posts"
  end

  create_table "posts", :force => true do |t|
    t.string   "brand_name"
    t.string   "post_id"
    t.string   "facebook_link"
    t.text     "post_copy"
    t.string   "post_type"
    t.datetime "post_date"
    t.string   "post_total_reach"
    t.string   "post_organic_reach"
    t.string   "post_paid_reach"
    t.string   "post_total_impressions"
    t.string   "post_organic_impressions"
    t.string   "post_paid_impressions"
    t.string   "post_lifetime_engaged_users"
    t.string   "post_lifetime_talking_about_this"
    t.string   "post_lifetime_negative_feedback_from_users"
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
    t.string   "post_consumptions_unique"
    t.string   "post_likes_stories"
    t.string   "post_comments_stories"
    t.string   "post_shares_stories"
    t.string   "post_likes_pta"
    t.string   "post_comments_pta"
    t.string   "post_shares_pta"
    t.string   "post_consumptions_total"
    t.string   "post_pta"
    t.integer  "brand_id"
    t.text     "post_thumbnail"
    t.string   "post_viral_impressions"
    t.string   "total_impressions_from_fans"
    t.string   "total_paid_impressions_from_fans"
    t.string   "post_viral_reach"
    t.string   "primary_tags",                               :limit => nil,                 :array => true
    t.string   "secondary_tags",                             :limit => nil,                 :array => true
  end

end
