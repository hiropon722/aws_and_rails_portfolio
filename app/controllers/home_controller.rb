class HomeController < ApplicationController
  include ApplicationHelper

  def index
    @log_message = log_active_window_information
    @log_saved = write_log(@log_message, current_user)
    @error_message = @error_message if !@log_saved
    date = Date.today
    @logs = current_user.logs.where(created_at: date.beginning_of_day..date.end_of_day)
    @os_info = get_active_window_title
  end
end
