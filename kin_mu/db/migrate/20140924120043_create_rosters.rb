class CreateRosters < ActiveRecord::Migration
  def change
    create_table :rosters do |t|

      t.timestamps
    end
  end
end
