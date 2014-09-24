class AddClmRoster < ActiveRecord::Migration
  def change
    add_column :rosters , :user_id, :integer
    add_column :rosters , :record_date, :date
    add_column :rosters , :working_start, :datetime
    add_column :rosters , :end_working, :datetime
    add_column :rosters , :work_description, :string

  end
end
