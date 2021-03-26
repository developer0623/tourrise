# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_21_091613) do

  create_table "action_text_rich_texts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", size: :long
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "availabilities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "starts_on"
    t.date "ends_on"
    t.bigint "inventory_id"
    t.index ["inventory_id"], name: "index_availabilities_on_inventory_id"
  end

  create_table "booking_attribute_values", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "booking_attribute_id"
    t.bigint "booking_resource_sku_id"
    t.string "name", null: false
    t.string "attribute_type", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "handle", null: false
    t.index ["booking_attribute_id"], name: "index_booking_attribute_values_on_booking_attribute_id"
    t.index ["booking_resource_sku_id", "handle"], name: "idx_b_attr_vals_on_b_res_sku_id_and_handle", unique: true
    t.index ["booking_resource_sku_id"], name: "index_booking_attribute_values_on_booking_resource_sku_id"
  end

  create_table "booking_attributes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "resource_type_id"
    t.string "attribute_type", default: "text", null: false
    t.string "name", null: false
    t.string "handle", null: false
    t.boolean "required", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["handle"], name: "index_booking_attributes_on_handle"
    t.index ["resource_type_id"], name: "index_booking_attributes_on_resource_type_id"
  end

  create_table "booking_customers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "booking_id"
    t.bigint "customer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["booking_id"], name: "index_booking_customers_on_booking_id"
    t.index ["customer_id"], name: "index_booking_customers_on_customer_id"
  end

  create_table "booking_flight_requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "booking_id"
    t.date "starts_on"
    t.date "ends_on"
    t.string "destination_airport"
    t.string "departure_airport"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_booking_flight_requests_on_booking_id"
  end

  create_table "booking_invoices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "booking_id"
    t.text "booking_snapshot"
    t.text "customer_snapshot"
    t.text "product_sku_snapshot"
    t.text "resource_skus_snapshot"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "booking_resource_skus_snapshot"
    t.text "booking_resource_sku_groups_snapshot"
    t.string "scrambled_id"
    t.index ["booking_id"], name: "index_booking_invoices_on_booking_id"
  end

  create_table "booking_offers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "booking_id"
    t.text "booking_snapshot"
    t.text "customer_snapshot"
    t.text "product_sku_snapshot"
    t.text "resource_skus_snapshot"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "booking_resource_skus_snapshot"
    t.text "booking_resource_sku_groups_snapshot"
    t.string "scrambled_id"
    t.datetime "accepted_at"
    t.datetime "rejected_at"
    t.index ["booking_id"], name: "index_booking_offers_on_booking_id"
  end

  create_table "booking_rentalbike_requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "booking_id"
    t.date "starts_on"
    t.date "ends_on"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_booking_rentalbike_requests_on_booking_id"
  end

  create_table "booking_rentalcar_requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "booking_id"
    t.date "starts_on"
    t.date "ends_on"
    t.string "rentalcar_class"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["booking_id"], name: "index_booking_rentalcar_requests_on_booking_id"
  end

  create_table "booking_resource_sku_availabilities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "booking_resource_sku_id"
    t.bigint "availability_id"
    t.bigint "blocked_by_id"
    t.datetime "blocked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "booked_by_id"
    t.datetime "booked_at"
    t.index ["availability_id"], name: "index_booking_resource_sku_availabilities_on_availability_id"
    t.index ["blocked_by_id"], name: "index_booking_resource_sku_availabilities_on_blocked_by_id"
    t.index ["booked_by_id"], name: "index_booking_resource_sku_availabilities_on_booked_by_id"
    t.index ["booking_resource_sku_id"], name: "idx_b_resource_sku_availabilities_on_b_resource_sku_id"
  end

  create_table "booking_resource_sku_customers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "booking_resource_sku_id"
    t.bigint "customer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["booking_resource_sku_id"], name: "idx_sku_customers_on_sku_id"
    t.index ["customer_id"], name: "idx_sku_customers_on_participant_id"
  end

  create_table "booking_resource_sku_flights", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "booking_resource_sku_id"
    t.bigint "flight_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["booking_resource_sku_id"], name: "index_booking_resource_sku_flights_on_booking_resource_sku_id"
    t.index ["flight_id"], name: "index_booking_resource_sku_flights_on_flight_id"
  end

  create_table "booking_resource_sku_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "booking_id"
    t.string "name", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "EUR", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "financial_account_id"
    t.bigint "cost_center_id"
    t.index ["booking_id"], name: "index_booking_resource_sku_groups_on_booking_id"
    t.index ["cost_center_id"], name: "index_booking_resource_sku_groups_on_cost_center_id"
    t.index ["financial_account_id"], name: "index_booking_resource_sku_groups_on_financial_account_id"
  end

  create_table "booking_resource_sku_groups_skus", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "booking_resource_sku_group_id"
    t.bigint "booking_resource_sku_id"
    t.index ["booking_resource_sku_group_id"], name: "idx_bkng_rsrc_sku_grps_skus_on_bkng_rsrc_sku_grp_id"
    t.index ["booking_resource_sku_id"], name: "idx_bkng_rsrc_sku_grps_skus_on_bkng_rsrc_sku_id"
  end

  create_table "booking_resource_sku_participants", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "booking_resource_sku_id"
    t.bigint "participant_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["booking_resource_sku_id"], name: "idx_sku_participants_on_sku_id"
    t.index ["participant_id"], name: "idx_sku_participants_on_participant_id"
  end

  create_table "booking_resource_skus", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "booking_id"
    t.bigint "resource_sku_id"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "EUR", null: false
    t.integer "quantity", default: 1, null: false
    t.text "resource_sku_snapshot"
    t.text "resource_snapshot"
    t.boolean "internal", default: false
    t.text "remarks"
    t.bigint "financial_account_id"
    t.bigint "cost_center_id"
    t.date "starts_on"
    t.date "ends_on"
    t.boolean "allow_partial_payment", default: true
    t.index ["booking_id"], name: "index_booking_resource_skus_on_booking_id"
    t.index ["cost_center_id"], name: "index_booking_resource_skus_on_cost_center_id"
    t.index ["financial_account_id"], name: "index_booking_resource_skus_on_financial_account_id"
    t.index ["resource_sku_id"], name: "index_booking_resource_skus_on_resource_sku_id"
  end

  create_table "booking_room_assignments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "booking_id"
    t.integer "adults"
    t.integer "kids"
    t.integer "babies"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_booking_room_assignments_on_booking_id"
  end

  create_table "bookings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "product_sku_id"
    t.bigint "customer_id"
    t.bigint "creator_id"
    t.string "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "starts_on"
    t.date "ends_on"
    t.integer "adults", default: 1, null: false
    t.integer "kids", default: 0, null: false
    t.bigint "assignee_id"
    t.string "aasm_state"
    t.datetime "canceled_at"
    t.integer "rooms_count"
    t.integer "rentalbikes_count"
    t.string "scrambled_id", null: false
    t.integer "flights_count"
    t.integer "babies", default: 0, null: false
    t.boolean "terms_of_service_accepted", default: false
    t.boolean "privacy_policy_accepted", default: false
    t.bigint "duplicate_of_id"
    t.date "due_on"
    t.integer "rentalcars_count"
    t.string "secondary_state"
    t.string "title"
    t.index ["assignee_id"], name: "index_bookings_on_assignee_id"
    t.index ["creator_id"], name: "index_bookings_on_creator_id"
    t.index ["customer_id"], name: "index_bookings_on_customer_id"
    t.index ["duplicate_of_id"], name: "index_bookings_on_duplicate_of_id"
    t.index ["product_sku_id"], name: "index_bookings_on_product_sku_id"
  end

  create_table "cost_centers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "custom_attribute_translations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "custom_attribute_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["custom_attribute_id"], name: "index_custom_attribute_translations_on_custom_attribute_id"
    t.index ["locale"], name: "index_custom_attribute_translations_on_locale"
  end

  create_table "custom_attribute_values", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "custom_attribute_id"
    t.string "attributable_type"
    t.bigint "attributable_id"
    t.text "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attributable_type", "attributable_id"], name: "custom_attribute_id_value_id"
    t.index ["custom_attribute_id"], name: "index_custom_attribute_values_on_custom_attribute_id"
  end

  create_table "custom_attributes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "handle"
    t.integer "field_type", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "customers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.date "birthdate"
    t.string "country"
    t.string "state"
    t.string "zip"
    t.text "address_line_1"
    t.text "address_line_2"
    t.string "city"
    t.string "email"
    t.string "primary_phone"
    t.string "secondary_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "newsletter", default: false
    t.string "company_name"
    t.string "locale", default: "de"
    t.integer "participant_type", default: 0, null: false
    t.boolean "placeholder", default: false
    t.integer "general_customer_id"
    t.index ["participant_type"], name: "index_customers_on_participant_type"
  end

  create_table "delayed_jobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "easybill_customer_syncs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "last_sync_at", null: false
  end

  create_table "easybill_customers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "customer_id"
    t.string "external_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_easybill_customers_on_customer_id"
  end

  create_table "easybill_employees", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.text "api_key"
    t.index ["user_id"], name: "index_easybill_employees_on_user_id"
  end

  create_table "easybill_invoices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "booking_invoice_id"
    t.string "external_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "canceled_at"
    t.string "external_number"
    t.index ["booking_invoice_id"], name: "index_easybill_invoices_on_booking_invoice_id"
  end

  create_table "easybill_offers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "booking_offer_id"
    t.string "external_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "external_number"
    t.index ["booking_offer_id"], name: "index_easybill_offers_on_booking_offer_id"
  end

  create_table "easybill_position_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "external_id", null: false
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_easybill_position_groups_on_resource_id"
  end

  create_table "easybill_positions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "external_id", null: false
    t.bigint "position_group_id"
    t.bigint "resource_sku_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position_group_id"], name: "index_easybill_positions_on_position_group_id"
    t.index ["resource_sku_id"], name: "index_easybill_positions_on_resource_sku_id"
  end

  create_table "easybill_product_configuration_translations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "easybill_product_configuration_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "invoice_template"
    t.text "offer_template"
    t.index ["easybill_product_configuration_id"], name: "index_13ee29438b9564f6b86d80a348a5ec1eb68ef1d3"
    t.index ["locale"], name: "index_easybill_product_configuration_translations_on_locale"
  end

  create_table "easybill_product_configurations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_easybill_product_configurations_on_product_id"
  end

  create_table "financial_accounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "before_service_year"
    t.string "during_service_year"
  end

  create_table "flights", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "airline_code"
    t.string "flight_number"
    t.string "aircraft_name"
    t.datetime "arrival_at"
    t.string "arrival_airport"
    t.datetime "departure_at"
    t.string "departure_airport"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "frontoffice_setting_translations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "frontoffice_setting_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "external_terms_of_service_url"
    t.string "external_privacy_policy_url"
    t.index ["frontoffice_setting_id"], name: "index_e4a167559370fd458385db24fc3c48eb4174453f"
    t.index ["locale"], name: "index_frontoffice_setting_translations_on_locale"
  end

  create_table "frontoffice_settings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "company_name"
    t.text "address_line_1"
    t.text "address_line_2"
    t.string "zip_code"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "phone"
    t.string "email"
    t.string "vat_id"
    t.string "external_document_preview_url"
  end

  create_table "frontoffice_steps", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "handle"
    t.string "description"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "global_configurations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "company_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "contact_email"
    t.string "contact_phone"
    t.decimal "partial_payment_percentage", precision: 5, scale: 2, default: "20.0"
    t.integer "term_of_final_payment", default: 30
    t.integer "term_of_first_payment", default: 10
  end

  create_table "inventories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "inventory_type", null: false
  end

  create_table "mailer_configurations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "frontoffice_inbox"
    t.string "sender"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "occupation_configurations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "min_occupancy"
    t.integer "max_occupancy"
    t.integer "min_adults"
    t.integer "max_adults"
    t.integer "min_kids", default: 0
    t.integer "max_kids", default: 0
    t.integer "min_babies", default: 0
    t.integer "max_babies", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "payments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "booking_invoice_id"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "EUR", null: false
    t.date "due_on"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["booking_invoice_id"], name: "index_payments_on_booking_invoice_id"
  end

  create_table "product_custom_attributes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "product_id"
    t.string "name"
    t.text "value"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_custom_attributes_on_product_id"
  end

  create_table "product_frontoffice_steps", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "frontoffice_step_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["frontoffice_step_id"], name: "index_product_frontoffice_steps_on_frontoffice_step_id"
    t.index ["product_id"], name: "index_product_frontoffice_steps_on_product_id"
  end

  create_table "product_option_values", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "option_id"
    t.string "value"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_id"], name: "index_product_option_values_on_option_id"
  end

  create_table "product_options", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "product_id"
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_options_on_product_id"
  end

  create_table "product_resources", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "resource_id"
    t.bigint "product_id"
    t.integer "position"
    t.index ["product_id"], name: "index_product_resources_on_product_id"
    t.index ["resource_id", "product_id"], name: "index_product_resources_on_resource_id_and_product_id", unique: true
    t.index ["resource_id"], name: "index_product_resources_on_resource_id"
  end

  create_table "product_sku_booking_configurations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "product_sku_id"
    t.integer "max_bookings"
    t.date "starts_on"
    t.date "ends_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "default_destination_airport_code"
    t.boolean "wishyouwhat_on_first_step", default: false
    t.index ["product_sku_id"], name: "index_product_sku_booking_configurations_on_product_sku_id"
  end

  create_table "product_sku_translations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "product_sku_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.text "description"
    t.index ["locale"], name: "index_product_sku_translations_on_locale"
    t.index ["product_sku_id"], name: "index_product_sku_translations_on_product_sku_id"
  end

  create_table "product_skus", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "product_id"
    t.text "barcode"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "handle", null: false
    t.bigint "financial_account_id"
    t.bigint "cost_center_id"
    t.index ["cost_center_id"], name: "index_product_skus_on_cost_center_id"
    t.index ["financial_account_id"], name: "index_product_skus_on_financial_account_id"
    t.index ["product_id"], name: "index_product_skus_on_product_id"
  end

  create_table "product_translations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "product_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.text "description"
    t.index ["locale"], name: "index_product_translations_on_locale"
    t.index ["product_id"], name: "index_product_translations_on_product_id"
  end

  create_table "product_variants", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "product_id"
    t.integer "product_sku_id"
    t.integer "product_option_id"
    t.integer "product_option_value_id"
    t.index ["product_id", "product_option_id"], name: "index_product_variants_on_product_id_and_product_option_id"
    t.index ["product_id", "product_sku_id"], name: "index_product_variants_on_product_id_and_product_sku_id"
    t.index ["product_id"], name: "index_product_variants_on_product_id"
    t.index ["product_option_id"], name: "index_product_variants_on_product_option_id"
    t.index ["product_option_value_id"], name: "index_product_variants_on_product_option_value_id"
    t.index ["product_sku_id", "product_option_id", "product_option_value_id"], name: "index_sku_option_and_option_value_ids", unique: true
    t.index ["product_sku_id", "product_option_id"], name: "index_product_variants_on_product_sku_id_and_product_option_id", unique: true
    t.index ["product_sku_id"], name: "index_product_variants_on_product_sku_id"
  end

  create_table "products", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "published_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "financial_account_id"
    t.bigint "cost_center_id"
    t.string "frontoffice_template", default: "default", null: false
    t.index ["cost_center_id"], name: "index_products_on_cost_center_id"
    t.index ["financial_account_id"], name: "index_products_on_financial_account_id"
  end

  create_table "resource_sku_flights", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "flight_id"
    t.bigint "resource_sku_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["flight_id"], name: "index_resource_sku_flights_on_flight_id"
    t.index ["resource_sku_id"], name: "index_resource_sku_flights_on_resource_sku_id"
  end

  create_table "resource_sku_inventories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "resource_sku_id"
    t.bigint "inventory_id"
    t.index ["inventory_id"], name: "index_resource_sku_inventories_on_inventory_id"
    t.index ["resource_sku_id", "inventory_id"], name: "idx_sku_inventories_on_sku_id_and_inventory_id", unique: true
    t.index ["resource_sku_id"], name: "index_resource_sku_inventories_on_resource_sku_id"
  end

  create_table "resource_sku_pricings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "resource_sku_id"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "EUR", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "purchase_price_cents", default: 0, null: false
    t.string "purchase_price_currency", default: "EUR", null: false
    t.integer "min_quantity"
    t.integer "participant_type", default: 0, null: false
    t.date "starts_on"
    t.date "ends_on"
    t.integer "calculation_type", default: 0, null: false
    t.index ["calculation_type"], name: "index_resource_sku_pricings_on_calculation_type"
    t.index ["participant_type"], name: "index_resource_sku_pricings_on_participant_type"
    t.index ["resource_sku_id"], name: "index_resource_sku_pricings_on_resource_sku_id"
  end

  create_table "resource_sku_translations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "resource_sku_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.text "description"
    t.index ["locale"], name: "index_resource_sku_translations_on_locale"
    t.index ["resource_sku_id"], name: "index_resource_sku_translations_on_resource_sku_id"
  end

  create_table "resource_skus", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "resource_id"
    t.string "handle"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "vat", precision: 5, scale: 2, default: "0.0", null: false
    t.boolean "available", default: true, null: false
    t.text "teaser_text"
    t.bigint "occupation_configuration_id"
    t.boolean "allow_partial_payment", default: true
    t.index ["handle"], name: "index_resource_skus_on_handle", unique: true
    t.index ["occupation_configuration_id"], name: "index_resource_skus_on_occupation_configuration_id"
    t.index ["resource_id"], name: "index_resource_skus_on_resource_id"
  end

  create_table "resource_translations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "resource_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.text "description"
    t.text "teaser_text"
    t.index ["locale"], name: "index_resource_translations_on_locale"
    t.index ["resource_id"], name: "index_resource_translations_on_resource_id"
  end

  create_table "resource_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "label", null: false
    t.string "handle", null: false
    t.index ["handle"], name: "index_resource_types_on_handle"
  end

  create_table "resources", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "resource_type_id"
    t.integer "featured_image_id"
    t.string "handle"
    t.index ["resource_type_id"], name: "index_resources_on_resource_type_id"
  end

  create_table "seasonal_product_skus", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "product_sku_id"
    t.bigint "season_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_sku_id"], name: "index_seasonal_product_skus_on_product_sku_id"
    t.index ["season_id"], name: "index_seasonal_product_skus_on_season_id"
  end

  create_table "seasons", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "product_id"
    t.string "name"
    t.datetime "published_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_seasons_on_product_id"
  end

  create_table "tag_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tag_translations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["locale"], name: "index_tag_translations_on_locale"
    t.index ["tag_id"], name: "index_tag_translations_on_tag_id"
  end

  create_table "taggables", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.bigint "tag_id"
    t.index ["tag_id"], name: "index_taggables_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggables_on_taggable_type_and_taggable_id"
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "handle"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "tag_group_id"
    t.index ["handle"], name: "index_tags_on_handle"
    t.index ["tag_group_id"], name: "index_tags_on_tag_group_id"
  end

  create_table "tolk_locales", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_tolk_locales_on_name", unique: true
  end

  create_table "tolk_phrases", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tolk_translations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "phrase_id"
    t.integer "locale_id"
    t.text "text"
    t.text "previous_text"
    t.boolean "primary_updated", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["phrase_id", "locale_id"], name: "index_tolk_translations_on_phrase_id_and_locale_id", unique: true
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: ""
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", size: :long
    t.datetime "created_at"
    t.text "object_changes", size: :long
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "booking_resource_sku_groups", "cost_centers"
  add_foreign_key "booking_resource_sku_groups", "financial_accounts"
  add_foreign_key "booking_resource_skus", "cost_centers"
  add_foreign_key "booking_resource_skus", "financial_accounts"
  add_foreign_key "product_skus", "cost_centers"
  add_foreign_key "product_skus", "financial_accounts"
  add_foreign_key "products", "cost_centers"
  add_foreign_key "products", "financial_accounts"
end
