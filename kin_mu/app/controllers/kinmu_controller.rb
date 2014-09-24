class KinmuController < ApplicationController

  def input
    @roster_db = Roster.new
    @today = Date.today
    begin
      @user_id = current_user.id
      @roster_db = Roster.find_by!(record_date: @today, user_id: @user_id)
      @record_date = db_serch.record_date
    rescue Exception => e
      puts e
      @record_date = Date.new
    end
  end

  def show
  end

  def update
    @record_date = params[:roster][:working_start]
  end
end

