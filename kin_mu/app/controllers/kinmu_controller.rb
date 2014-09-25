class KinmuController < ApplicationController
  def not_input?(param_string)
    return true if param_string.blank?
  end 
  def input
    @roster_db = Roster.new
    @today = Date.today
    @user_id = current_user.id
	@record_date = @today if not_input?(params[:disp_date])

    begin
      db_serch = Roster.find_by!(record_date: @today, user_id: @user_id)
      @record_date = db_serch.record_date
      # ラベル情報の更新
      @roster_db.working_start     = db_serch.working_start.strftime("%X")
      @roster_db.end_working       = db_serch.end_working.strftime("%X")
      @roster_db.work_description  = db_serch.work_description
    rescue Exception => e
      puts "--例外発生 #{e}\n"
      @roster_db.working_start = DateTime.now.strftime("%X")
      @roster_db.end_working   = DateTime.now.strftime("%X")
    end

  end

  def show
  end

  def update
    update_db = Roster.new
	# 更新か、追加か？
    begin
      update_db = Roster.find_by!(record_date: params[:roster][:record_date], user_id: params[:roster][:user_id])
    rescue Exception => e
      puts "--データ新規追加 #{e}"
    end
    begin
      update_db.record_date      = params[:roster][:record_date]
      update_db.user_id          = params[:roster][:user_id]
      update_db.working_start    = params[:roster][:working_start]
      update_db.end_working      = params[:roster][:end_working]
      update_db.work_description = params[:roster][:work_description]
      result = "error"
      if update_db.save 
        @result = "complete"
      end
    rescue Exception => e
      @result = e
    end
  end
end

