class SchedulesController < ApplicationController
    before_action :authenticate_user!  # Deviseの認証が必要な場合
  
  def index
    @schedules = current_user.schedules.where("day >= ?", Date.current).where("day < ?", Date.current >> 3).order(day: :desc)
  end

  def new
    @schedule = Schedule.new
    @day = params[:day]
    @time = params[:time]
    @start_time = DateTime.parse(@day + " " + @time + " " + "JST")
  end

  def show
    @schedule = Schedule.find(params[:id])
  end

  def create
    @schedule = Schedule.new(schedule_params)
    if @schedule.save
      redirect_to schedules_path , notice: 'スケジュールが作成されました'
    else
      render :new
    end
  end
  
  private
  def schedule_params
    params.require(:schedule).permit(:day, :time, :user_id, :start_time)
  end
  
end
