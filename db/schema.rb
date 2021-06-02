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

ActiveRecord::Schema.define(version: 2020_10_12_101052) do

  create_table "banks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "image"
    t.json "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "has_page", default: false
  end

  create_table "blogs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "brand_id"
    t.bigint "new_car_id"
    t.json "images"
    t.string "url"
    t.json "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_blogs_on_brand_id"
    t.index ["new_car_id"], name: "index_blogs_on_new_car_id"
  end

  create_table "brands", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.string "menutitle"
    t.json "description"
    t.string "logo"
    t.string "logoblack"
    t.string "cert"
    t.string "url"
    t.boolean "official", default: true
    t.boolean "menu_show", default: false
    t.boolean "hide", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "main_img"
  end

  create_table "equipment", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "specification_id"
    t.bigint "equipment_description_id"
    t.integer "price"
    t.string "suffix"
    t.boolean "hide", default: false
    t.json "other_prices"
    t.integer "good_price", default: 1
    t.datetime "updated_at"
    t.index ["equipment_description_id"], name: "index_equipment_on_equipment_description_id"
    t.index ["specification_id"], name: "index_equipment_on_specification_id"
  end

  create_table "equipment_descriptions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "new_car_id"
    t.string "name"
    t.text "description"
    t.json "compare"
    t.json "comparedesc"
    t.index ["new_car_id"], name: "index_equipment_descriptions_on_new_car_id"
  end

  create_table "finances", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.json "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "new_cars", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "brand_id"
    t.string "name"
    t.string "russian_name"
    t.string "menutitle"
    t.json "description"
    t.boolean "old", default: false
    t.string "url"
    t.integer "discount", default: 50000
    t.integer "discount_credit", default: 40000
    t.integer "discount_tradein", default: 60000
    t.boolean "half_discount", default: false
    t.string "car_type"
    t.string "car_link"
    t.string "country"
    t.string "warranty"
    t.string "special_options"
    t.string "video_link"
    t.json "colors"
    t.json "color_options"
    t.json "images"
    t.json "images360"
    t.boolean "hide", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "archive", default: false
    t.string "color_group"
    t.boolean "available", default: true
    t.text "special_text"
    t.index ["brand_id"], name: "index_new_cars_on_brand_id"
  end

  create_table "regions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "sklon1"
    t.string "sklon2"
    t.string "sklon3"
  end

  create_table "reviews", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.text "rev_text"
    t.bigint "new_car_id"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["new_car_id"], name: "index_reviews_on_new_car_id"
  end

  create_table "specifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "new_car_id"
    t.string "name"
    t.string "enginetype"
    t.integer "volume"
    t.integer "power"
    t.float "acceleration"
    t.integer "topspeed"
    t.float "fuelcity"
    t.float "fuelhigh"
    t.float "fuelmix"
    t.integer "tank"
    t.integer "length"
    t.integer "width"
    t.integer "height"
    t.integer "wheelbase"
    t.integer "clearance"
    t.integer "mass"
    t.integer "trunk"
    t.string "transmission"
    t.string "shorttransmission"
    t.string "drive"
    t.string "frontsusp"
    t.string "rearsusp"
    t.string "frontbrakes"
    t.string "rearbrakes"
    t.index ["new_car_id"], name: "index_specifications_on_new_car_id"
  end

  create_table "stories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.text "newstext"
    t.bigint "brand_id"
    t.string "newsImage"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_stories_on_brand_id"
  end

  create_table "tickets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "form_name"
    t.string "form_url"
    t.integer "send_to_crm"
    t.json "utm_info"
    t.json "udata"
    t.json "other"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "used_cars", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "menutitle"
    t.string "url"
    t.bigint "brand_id"
    t.integer "price"
    t.integer "odometer"
    t.integer "owners"
    t.string "condition"
    t.integer "year"
    t.string "vin"
    t.string "color"
    t.boolean "avito"
    t.string "car_type"
    t.json "images"
    t.string "transmission"
    t.decimal "volume", precision: 10, scale: 2
    t.integer "power"
    t.json "complectation"
    t.string "drive"
    t.boolean "used"
    t.boolean "hide"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "sold", default: false
    t.text "special_text"
    t.boolean "taxi", default: false
    t.string "taxi_type"
    t.integer "girl", limit: 1
    t.integer "first", limit: 1
    t.integer "biznes", limit: 1
    t.integer "family", limit: 1
    t.integer "young", limit: 1
    t.integer "dacha", limit: 1
    t.integer "job", limit: 1
    t.index ["brand_id"], name: "index_used_cars_on_brand_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.datetime "last_login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", limit: 1
  end

  add_foreign_key "blogs", "brands"
  add_foreign_key "blogs", "new_cars"
  add_foreign_key "equipment", "equipment_descriptions"
  add_foreign_key "equipment", "specifications"
  add_foreign_key "equipment_descriptions", "new_cars"
  add_foreign_key "new_cars", "brands"
  add_foreign_key "reviews", "new_cars"
  add_foreign_key "specifications", "new_cars"
  add_foreign_key "stories", "brands"
  add_foreign_key "used_cars", "brands"
end
