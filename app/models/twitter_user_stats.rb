class TwitterUserStats < MongoRecord::Base  
  # from twittercounter
  
  fields :screen_name
  fields :followers_current
  fields :started_followers
  fields :growth_since
  fields :tomorrow
  fields :next_month
  fields :followers_yesterday
  fields :followers_2w_ago
  fields :growth_since_2w
  fields :tomorrow_2w
  fields :next_month_2w
  fields :average_growth
  fields :average_growth_2w
  fields :rank
  fields :follower_counts
  fields :followers_change_last_seven_days
  fields :followers_change_last_thirty_days
  fields :daily_stats
  
  # from followcost
  
  fields :milliscobles_all_time
  fields :average_tweets_per_day
  fields :twitter_created_at
  fields :at_reply_index
  fields :milliscobles_recently
  fields :average_tweets_per_day_recently
  fields :political_index
        
  def totals
    self.followersperdate.map{|day| [Time.parse(day[0]).to_i*1000, day[1]]}  
  end
  
  def self.fetch(screen_name)
    return if screen_name.blank?
    counter_stats = JSON.parse(Net::HTTP.get(URI.parse("http://twittercounter.com/api/?username=#{screen_name}&output=json&results=365")))
    vitals = JSON.parse(Net::HTTP.get(URI.parse("http://followcost.com/#{screen_name}.json")))
    stats = TwitterUserStats.new(counter_stats.merge(vitals))
    # stats come in from TwitterCounter in a hash
    # converting to an array for easier access
    stats.follower_counts = stats.followersperdate.to_a
    if stats.follower_counts
      stats.follower_counts.map! do |day|
        date = Date.parse(day[0].gsub('date', ''))
        count = day[1].to_i
        [date, count]
      end
      stats.follower_counts = stats.follower_counts.sort_by{|day| day[0]}
      stats.daily_stats = stats.follower_counts.reverse
      stats.followers_change_last_seven_days = (stats.daily_stats[0][1].to_i - stats.daily_stats[6][1].to_i) rescue nil
      stats.followers_change_last_thirty_days = (stats.daily_stats[0][1].to_i - stats.daily_stats[29][1].to_i) rescue nil
    end
    stats
  end
end
