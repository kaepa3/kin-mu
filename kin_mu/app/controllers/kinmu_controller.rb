class KinmuController < ApplicationController
  def GetDspDate(param)
    return Date.today if param.blank?
    return Date.new(param[:"date(1i)"].to_i, param[:"date(2i)"].to_i, param[:"date(3i)"].to_i)
  end
  def input
    @roster_db = Roster.new
    @today = Date.today
    @user_id = current_user.id
    @record_date = GetDspDate(params[:dsp_date])

    begin
      db_serch = Roster.find_by!(record_date: @record_date, user_id: @user_id)
      # ラベル情報の更新
      @roster_db.working_start     = db_serch.working_start.strftime("%X")
      @roster_db.end_working       = db_serch.end_working.strftime("%X")
      @roster_db.work_description  = db_serch.work_description
    rescue Exception => e
      @roster_db.working_start    = @record_date.to_time.to_datetime
      @roster_db.end_working      = @record_date.to_time.to_datetime
      @roster_db.work_description = ""
      puts "--例外発生 #{e} #{@record_date}　#{@roster_db.end_working.class}"

    end

  end

  def show
    @date_from = Date.today.beginning_of_month
    @date_to   = Date.today.end_of_month
    @serch_result = Roster.where("user_id == ? and record_date >= ? and record_date <= ? ",current_user.id, @date_from, @date_to)
  end

  def update
    update_db = Roster.new
	# 更新か、追加か？
    begin
      update_db = Roster.find_by!(record_date: params[:roster][:record_date], user_id: params[:roster][:user_id])
    rescue Exception => e
      puts "--データ新規追加 #{e} #{params[:roster]} #{params[:roster][:end_working].class}"
    end
    begin
      update_db.record_date      = params[:roster][:record_date]
      update_db.user_id          = params[:roster][:user_id]
      update_db.working_start    = params[:roster][:record_date] + " " + params[:roster][:working_start]
      update_db.end_working      = params[:roster][:record_date] + " " + params[:roster][:end_working]
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

