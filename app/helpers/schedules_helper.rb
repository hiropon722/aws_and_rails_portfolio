module SchedulesHelper
  def times
    times = ["9:00",
             "9:30",
             "10:00",
             "10:30",
             "11:00",
             "11:30",
             "13:00",
             "13:30",
             "14:00",
             "15:00",
             "15:30",
             "16:00",
             "16:30",
             "17:30",
             "18:00",
             "18:30",
             "19:00"]
  end
  
  def check_schedule(schedules, day, time)
    result = false
    schedules_count = schedules.count
    # 取得した予約データにdayとtimeが一致する場合はtrue,一致しない場合はfalseを返します
    if schedules_count > 1
      schedules.each do |schedule|
        result = schedule[:day].eql?(day.strftime("%Y-%m-%d")) && schedule[:time].eql?(time)
        return result if result
      end
    elsif schedules_count == 1
      result = schedules[0][:day].eql?(day.strftime("%Y-%m-%d")) && schedules[0][:time].eql?(time)
      return result if result
    end
    return result
  end
  
def find_schedule(schedules, day, time)
  schedules.find { |schedule| schedule[:day] == day && schedule[:time] == time }
end

end
