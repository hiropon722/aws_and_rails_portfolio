class SchedulesController < ApplicationController
    before_action :authenticate_user!  # Deviseの認証が必要な場合
  
  def index
    @schedule = Schedule.new(user_id: current_user.id)
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
   
  def edit
    @schedule = Schedule.find(params[:id])
  end


  def create
    # フォームから day と time を受け取り、starttime を生成
    day = params[:schedule][:day]
    time = params[:schedule][:time]
    start_time = "#{day} #{time}:00"
    # スケジュールを作成
    @schedule = Schedule.new(schedule_params)
    @schedule.start_time = start_time
    if @schedule.save
      flash[:notice] = "スケジュールが作成されました"
      redirect_to schedules_path
    else
      render :index
    end

  end
  
  def update
    # フォームから day と time を受け取り、start_time を生成
    day = params[:schedule][:day]
    time = params[:schedule][:time]
    start_time = "#{day} #{time}:00"
  
    # 既存のスケジュールを取得
    @schedule = Schedule.find(params[:id])
  
    # スケジュールの属性を更新
    @schedule.assign_attributes(schedule_params)
    @schedule.start_time = start_time
  
    if @schedule.save
      flash[:notice] = "スケジュールを更新しました"
      redirect_to schedules_path
    else
      render :edit
    end
  end

 
 def destroy
     @schedule = Schedule.find(params[:id]) # スケジュールを見つけて設定する
     @schedule.destroy
	   flash[:notice] = "スケジュールを削除しました"
	   redirect_to schedules_path
 end
  
  private
  def schedule_params
    params.require(:schedule).permit(:plan, :day, :time, :user_id, :start_time, :end_time, :importance)
  end
  
end
