class CreateAthleteClicks < ActiveRecord::Migration
  def change
    create_table :athlete_clicks do |t|
      t.belongs_to :user, index: true, null: true # allow anonymous click counts
      t.belongs_to :athlete, index: true, null: false
      t.timestamps
    end
    add_column :athletes, :clicks_count, :integer, default: 0, null: false
    add_index :athletes, :clicks_count
  end
end
