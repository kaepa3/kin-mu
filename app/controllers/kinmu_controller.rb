
class KinmuController < ApplicationController
  def GetDspDate(param)
    unless param[:dsp_date].blank?
      return Date.new(param[:dsp_date][:"date(1i)"].to_i, param[:dsp_date][:"date(2i)"].to_i, param[:dsp_date][:"date(3i)"].to_i)
    end
    unless  param[:ye].blank?
      return Date.new(param[:ye].to_i, param[:mo].to_i, param[:day].to_i)
    end

    return Date.today
  end
  def input
    @roster_db = Roster.new
    @today = Date.today
    @record_date = GetDspDate(params)
    begin
      db_serch = Roster.find_by!(record_date: @record_date, user_id: current_user.id)
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
  def GetShowDate(params)
    return Date.today.beginning_of_month if params["dsp_year"].blank?
    return Date.new(params["dsp_year"].to_i, params["dsp_month"].to_i, 1)
  end
  def show
    @date_from = GetShowDate(params)
    @date_to   = @date_from.end_of_month
    @this_month_string = @date_from.strftime("%Y %m")
    # 見難いので取得
	last_month  = @date_from.months_ago(1)
	next_month  = @date_from.months_since(1)
	# 設定する
	@last_month_string = last_month.strftime("%Y %m")
	@next_month_string = next_month.strftime("%Y %m")
	@last_month_url = "?dsp_year=#{last_month.strftime("%Y")}&dsp_month=#{last_month.strftime("%m")}"
	@next_month_url = "?dsp_year=#{next_month.strftime("%Y")}&dsp_month=#{next_month.strftime("%m")}"
    @serch_result = Roster.where("user_id == ? and record_date >= ? and record_date <= ? ",current_user.id.to_i, @date_from, @date_to).order(:record_date)
    DLFileMaker(@serch_result, current_user.id)
  end

  def DLFileMaker(data_base_records, user_id)
	output_records = []
    data_base_records.each{|record|
		text = ""
		# 開始時間
		text += ", #{record.working_start.strftime("%H")}, #{record.working_start.strftime("%M")}"
		# 終了時間
		text += ", #{record.end_working.strftime("%H")}, #{record.end_working.strftime("%M")}"
		# 備考
		text += ", #{record.work_description}"
		output_records << text
    }
	# ファイル出力
#	puts "-ddd #{output_records }"
  end
  def update

    update_db = Roster.new

    unless params[:delete].blank?
      update_db = Roster.find_by!(record_date: params[:delete], user_id: current_user.id)
      update_db.destroy
      @result = "delete"
      return
    end

    # 更新か、追加か？
    begin
      update_db = Roster.find_by!(record_date: params[:roster][:record_date], user_id: current_user.id)
    rescue Exception => e
      puts "--データ新規追加 #{e} #{params[:roster]} #{params[:roster][:end_working].class}"
    end

    begin
      update_db.record_date      = params[:roster][:record_date]
      update_db.user_id          = current_user.id
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

