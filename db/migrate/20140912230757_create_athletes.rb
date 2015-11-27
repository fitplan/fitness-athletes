class CreateAthletes < ActiveRecord::Migration
  def change
    create_table :athletes do |t|
      t.string :title,    null: false
      t.integer :user_id, null: false
      t.string :type,     null: false, default: 'Athlete::Base'
      t.text :description
      t.string :url
      t.string :instagram_url
      t.string :avatar_url
      t.timestamps
    end

    add_index :athletes, :user_id
  end
end
