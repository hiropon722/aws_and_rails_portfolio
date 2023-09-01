class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
create_table "schedules", force: :cascade do |t|
    t.string :plan, null: false
    t.date "day", null: false
    t.string "time", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "start_time", null: false # デフォルト値を設定
    t.string :importance, null: false
    t.index ["user_id"], name: "index_schedules_on_user_id"
    end
  end
end
