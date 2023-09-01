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
    times = params[:schedule][:time]
    success = true  # スケジュールの作成が成功したかどうかを示すフラグ
    year = params[:schedule]['day(1i)']
    month = params[:schedule]['day(2i)']
    day = params[:schedule]['day(3i)']
    selected_date = "#{year}-#{month}-#{day}"

    if times.nil? || times.empty?
      success = false
    else
      times.each do |time|
      start_datetime = Time.zone.parse("#{selected_date} #{time}")
      existing_schedule = Schedule.find_by(day: selected_date, time: time)
      
      @schedule = Schedule.new(schedule_params)  # @schedule オブジェクトを事前に初期化
      
      if existing_schedule
        # 既存のスケジュールが存在する場合、エラーメッセージを設定して処理を中止
        @schedule.errors.add(:base, "指定した日時には既に予定が存在します")
        success = false
      else
          # 既存のスケジュールが存在しない場合、新しいスケジュールを作成
        @schedule = Schedule.new(schedule_params)
        @schedule.start_time = start_datetime
        @schedule.time = time
        
        if !@schedule.valid?
          success = false  # 一つでもエラーがあれば success を false に設定
        end
      end
    end
    end

    if success
      # 全ての時間スロットが正常の場合の処理
      times.each do |time|
        start_datetime = Time.zone.parse("#{selected_date} #{time}")
        @schedule = Schedule.new(schedule_params)
        @schedule.start_time = start_datetime
        @schedule.time = time
        @schedule.save
      end
      flash[:notice] = "スケジュールが作成されました"
      redirect_to schedules_path
    else
      flash[:alert] = "スケジュールの作成に失敗しました"
      redirect_to schedules_path
    end
  end
  
def update
  @schedule = Schedule.find(params[:id])

  # スケジュールの更新が成功したかどうかを示すフラグ
  success = true

  if @schedule.update(schedule_params)
    flash[:notice] = "スケジュールが更新されました"
  else
    flash[:alert] = "スケジュールの更新に失敗しました"
    success = false
  end

  if success
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
      params.require(:schedule).permit(:plan, :day, :importance, :user_id, :time => [])
    end

  
end
