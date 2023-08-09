class Schedule < ApplicationRecord
    belongs_to :user
    
    
    def self.schedules_after_three_month
    # 今日から3ヶ月先までのデータを取得
    schedules = Schedule.all.where("day >= ?", Date.current).where("day < ?", Date.current >> 3).order(day: :desc)
    # 配列を作成し、データを格納
    # DBアクセスを減らすために必要なデータを配列にデータを突っ込んでます
    schedule_data = []
    schedules.each do |schedule|
      schedules_hash = {}
      schedules_hash.merge!(day: schedule.day.strftime("%Y-%m-%d"), time: schedule.time)
      schedule_data.push(schedules_hash)
    end
    schedule_data
  end
end
