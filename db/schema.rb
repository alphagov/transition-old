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

ActiveRecord::Schema.define(:version => 20130724142922) do

  create_table "content_types", :force => true do |t|
    t.string   "type"
    t.string   "subtype"
    t.boolean  "scrapable"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.boolean  "user_need_required",  :default => false
    t.boolean  "mandatory_url_group", :default => false, :null => false
  end

  add_index "content_types", ["type", "subtype"], :name => "index_content_types_on_type_and_subtype", :unique => true

  create_table "content_types_scrapable_fields", :force => true do |t|
    t.integer "content_type_id"
    t.integer "scrapable_field_id"
  end

  add_index "content_types_scrapable_fields", ["scrapable_field_id", "content_type_id"], :name => "index_content_type_scrapable_field", :unique => true

  create_table "hits", :force => true do |t|
    t.integer "host_id",                     :null => false
    t.string  "path",        :limit => 1024, :null => false
    t.string  "path_hash",   :limit => 40,   :null => false
    t.string  "http_status", :limit => 3,    :null => false
    t.integer "count",                       :null => false
    t.date    "hit_on",                      :null => false
  end

  add_index "hits", ["host_id", "hit_on"], :name => "index_hits_on_host_id_and_hit_on"
  add_index "hits", ["host_id", "http_status"], :name => "index_hits_on_host_id_and_http_status"
  add_index "hits", ["host_id", "path_hash", "hit_on", "http_status"], :name => "index_hits_on_host_id_and_path_hash_and_hit_on_and_http_status", :unique => true
  add_index "hits", ["host_id"], :name => "index_hits_on_host_id"

  create_table "hosts", :force => true do |t|
    t.integer  "site_id"
    t.string   "host"
    t.integer  "ttl"
    t.string   "cname"
    t.string   "live_cname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "hosts", ["host"], :name => "index_hosts_on_host", :unique => true
  add_index "hosts", ["site_id"], :name => "index_hosts_on_site_id"

  create_table "mappings", :force => true do |t|
    t.integer "site_id",                       :null => false
    t.string  "path",          :limit => 1024, :null => false
    t.string  "path_hash",     :limit => 40,   :null => false
    t.string  "http_status",   :limit => 3,    :null => false
    t.text    "new_url"
    t.text    "suggested_url"
    t.text    "archive_url"
  end

  add_index "mappings", ["site_id", "http_status"], :name => "index_mappings_on_site_id_and_http_status"
  add_index "mappings", ["site_id", "path_hash"], :name => "index_mappings_on_site_id_and_path_hash", :unique => true
  add_index "mappings", ["site_id"], :name => "index_mappings_on_site_id"

  create_table "organisations", :force => true do |t|
    t.string   "abbr"
    t.string   "title"
    t.date     "launch_date"
    t.string   "homepage"
    t.string   "furl"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "css"
    t.boolean  "manages_own_redirects", :default => false, :null => false
  end

  add_index "organisations", ["abbr"], :name => "index_organisations_on_abbr", :unique => true

  create_table "scrapable_fields", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "mandatory",  :default => false, :null => false
  end

  create_table "scrape_results", :force => true do |t|
    t.text     "data",           :limit => 16777215
    t.integer  "scrapable_id",                       :null => false
    t.string   "scrapable_type",                     :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "scrape_results", ["scrapable_id", "scrapable_type"], :name => "index_scrape_results_on_scrapable_id_and_scrapable_type"

  create_table "sites", :force => true do |t|
    t.integer  "organisation_id"
    t.string   "site"
    t.string   "query_params"
    t.datetime "tna_timestamp"
    t.string   "homepage"
    t.string   "furl"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "sites", ["organisation_id"], :name => "index_sites_on_organisation_id"
  add_index "sites", ["site"], :name => "index_sites_on_site", :unique => true

  create_table "totals", :force => true do |t|
    t.integer "host_id",                  :null => false
    t.string  "http_status", :limit => 3, :null => false
    t.integer "count",                    :null => false
    t.date    "total_on",                 :null => false
  end

  add_index "totals", ["host_id", "total_on", "http_status"], :name => "index_totals_on_host_id_and_total_on_and_http_status", :unique => true

  create_table "url_group_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "url_groups", :force => true do |t|
    t.string   "name",              :null => false
    t.integer  "url_group_type_id", :null => false
    t.integer  "organisation_id",   :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "url_groups", ["organisation_id"], :name => "index_url_groups_on_organisation_id"
  add_index "url_groups", ["url_group_type_id", "organisation_id", "name"], :name => "index_url_groups_on_group_type_organisation_and_name"

  create_table "urls", :force => true do |t|
    t.string   "url",             :limit => 2048,                    :null => false
    t.integer  "site_id",                                            :null => false
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "state",                           :default => "new", :null => false
    t.text     "comments"
    t.boolean  "for_scraping"
    t.integer  "url_group_id"
    t.integer  "user_need_id"
    t.integer  "content_type_id"
    t.boolean  "scrape_finished",                 :default => false, :null => false
  end

  add_index "urls", ["site_id"], :name => "index_urls_on_site_id"
  add_index "urls", ["url_group_id"], :name => "index_urls_on_url_group_id"
  add_index "urls", ["user_need_id"], :name => "index_urls_on_user_need_id"

  create_table "user_needs", :force => true do |t|
    t.string   "name",            :null => false
    t.integer  "organisation_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "as_a"
    t.text     "i_want_to"
    t.text     "so_that"
    t.string   "needotron_id"
  end

  add_index "user_needs", ["needotron_id"], :name => "index_user_needs_on_needotron_id"
  add_index "user_needs", ["organisation_id", "name"], :name => "index_user_needs_on_organisation_id_and_name"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "uid"
    t.text     "permissions"
    t.boolean  "remotely_signed_out", :default => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

end
