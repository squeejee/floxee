class TwitterUserStats < CouchRest::ExtendedDocument
  use_database CouchRest.database!(Floxee.server)
  
  # from twittercounter
  
  property :followers_current
  property :started_followers
  property :growth_since
  property :tomorrow
  property :next_month
  property :followers_yesterday
  property :followers_2w_ago
  property :growth_since_2w
  property :tomorrow_2w
  property :next_month_2w
  property :average_growth
  property :average_growth_2w
  property :rank
  property :followers_change_last_seven_days
  property :followers_change_last_thirty_days
  property :daily_stats, :cast_as => ['Array']
  
  # from followcost
  
  property :milliscobles_all_time
  property :average_tweets_per_day
  property :twitter_created_at
  property :at_reply_index
  property :milliscobles_recently
  property :average_tweets_per_day_recently
  property :political_index
  
  
  view_by :screen_name
  
  def screen_name=value
    self['screen_name'] = value
    self.fetch
  end
  
  def screen_name
    self['screen_name']
  end
  
  def totals
    self.daily_stats.map{|day| [Time.parse(day[0]).to_i*1000, day[1]]}
  
  end
  
  def fetch
    return if screen_name.blank?
    self.merge!(JSON.parse(Net::HTTP.get(URI.parse("http://twittercounter.com/api/?username=#{self.screen_name}&output=json&results=365"))))
    # stats come in from TwitterCounter in a hash
    # converting to an array for easier access
    follower_counts = self.delete('followersperdate')
    if follower_counts
      follower_counts = follower_counts.to_a
      follower_counts.map! do |day|
        date = Date.parse(day[0].gsub('date', ''))
        count = day[1].to_i
        [date, count]
      end
      follower_counts = follower_counts.sort_by{|day| day[0]}
      self.daily_stats = follower_counts.reverse
      self.followers_change_last_seven_days = (self.daily_stats[0][1].to_i - self.daily_stats[6][1].to_i) rescue nil
      self.followers_change_last_thirty_days = (self.daily_stats[0][1].to_i - self.daily_stats[29][1].to_i) rescue nil
    end
    
    # fetch stats from followcost.com
    self.merge!(JSON.parse(Net::HTTP.get(URI.parse("http://followcost.com/#{self.screen_name}.json"))))
    self.save
  end
end
