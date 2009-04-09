class CreateStats < ActiveRecord::Migration
  def self.up
    create_table :stats do |t|
      t.integer :user_id
      t.integer :followers_current
      t.integer :started_followers
      t.integer :growth_since
      t.integer :tomorrow
      t.integer :next_month
      t.integer :followers_yesterday
      t.integer :followers_2w_ago
      t.integer :growth_since_2w
      t.integer :tomorrow_2w
      t.integer :next_month_2w
      t.integer :average_growth
      t.integer :average_growth_2w
      t.integer :rank
      t.integer :followers_change_last_seven_days
      t.integer :followers_change_last_thirty_days
      t.float :milliscobles_all_time
      t.float :average_tweets_per_day
      t.float :at_reply_index
      t.float :milliscobles_recently
      t.float :average_tweets_per_day_recently
      t.float :political_index
      t.float :golden_index

      t.timestamps
    end
  end

  def self.down
    drop_table :stats
  end
end
