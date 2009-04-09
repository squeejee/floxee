class CreateDailyStats < ActiveRecord::Migration
  def self.up
    create_table :daily_stats do |t|
      t.integer :user_id
      t.datetime :report_date
      t.integer :followers_count

      t.timestamps
    end
  end

  def self.down
    drop_table :daily_stats
  end
end
