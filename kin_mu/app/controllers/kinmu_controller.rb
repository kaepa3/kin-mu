class KinmuController < ApplicationController

  def input
    @roster_db = Roster.new
    @today = Date.today
#    @roster_db = Roster.where(:record_date => @today)
  end

  def show
  end
end

