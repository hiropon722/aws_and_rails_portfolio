class LogsController < ApplicationController
  # 他のアクションと同様に、アクションを定義します
  
  def save_log
    log_params = {
      log_message: params[:windowInfo],
      user: current_user
    }
    @log = Log.new(log_params)

    if @log.save
      head :ok
    else
      head :unprocessable_entity
    end
  end
  
  def save_active_window
    active_window_info = params[:active_window]
    log = Log.new(log_message: active_window_info, user: current_user)
    
    if log.save
      head :ok
    else
      head :unprocessable_entity
    end
  end
  
end


