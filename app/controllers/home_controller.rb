class HomeController < ApplicationController

  def index
    date = Date.today
    @logs = current_user.logs.where(created_at: date.beginning_of_day..date.end_of_day)
  end
end
