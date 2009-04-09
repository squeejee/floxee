class User < TwitterAuth::GenericUser
  # Extend and define your user model as you see fit.
  # All of the authentication logic is handled by the 
  # parent TwitterAuth::GenericUser class.

  has_one :stats, :class_name => "Stats", :dependent => :destroy
  has_many :daily_stats, :class_name => "DailyStats", :order => 'report_date ASC', :dependent => :destroy
  has_many :statuses, :order => 'id DESC', :dependent => :destroy
  
  named_scope :synced, :conditions => ['last_synced_at IS NOT NULL']
  
  
  def screen_name
    self.login
  end
  
  def screen_name=(value)
    self.login = value
  end
  
  def sync
    begin
      user_id = self.id
      info = User.twitter_client.users.show.json(:id => user_id)
      info = info.marshal_dump.stringify_keys
      self.assign_twitter_attributes(info)
      self.id = user_id
      self.login = info['screen_name']
      self.last_synced_at = Time.now
    
      self.save
    rescue Grackle::TwitterError
      RAILS_DEFAULT_LOGGER.error "Could not sync #{self.id}"
    end
  end
  
  def fetch_latest_statuses
    self.fetch_statuses(1, self.statuses.maximum(:id))
  end
  
  def fetch_statuses(page=1, since_id=1)
    return unless self.statuses_count.to_i > 0
    more_tweets = true
    while more_tweets
       tweet_count = fetch_statuses_page(page, since_id)
       more_tweets = (tweet_count == 20)
       page += 1
    end
    
    
  end
  
  def after_save
    if self.stats.nil?
      unless self.login.blank?
        self.create_stats and self.stats.sync
      end
    end
  end

  
  def self.find_or_create_by_screen_name(screen_name)
    u = User.find_by_login(screen_name)
    return u unless u.nil?
    begin
      info = User.twitter_client.users.show.json(:screen_name => screen_name)
      u = User.find_or_create_by_id(info.id)
      u.assign_twitter_attributes(info.marshal_dump.stringify_keys)
      u.id = info.id
      u.login = info.screen_name
      u.last_synced_at = Time.now
      u.save!
      u
    rescue Grackle::TwitterError
      RAILS_DEFAULT_LOGGER.error "Could not retrieve user #{screen_name}"
      
    end
  end
  
  def self.twitter_client
    @twitter_client ||= Grackle::Client.new(:username => Floxee.username, :password => Floxee.password)
  end

  protected
    
    def fetch_statuses_page(page, since_id)
      begin
        tweets = User.twitter_client.statuses.user_timeline.json(:user_id => self.id, :page => page, :since_id => since_id)
        tweets.each do |tweet|
          tweet.delete_field('user')
          status_id = tweet.id
          status = Status.find_or_create_by_id(status_id)
          status.user_id = self.id
          status.attributes = tweet.marshal_dump 
          status.created_at = tweet.created_at
          status.save
        end
        tweets.size
      rescue Grackle::TwitterError
        RAILS_DEFAULT_LOGGER.error "Could not retrieve statuses for  #{self.screen_name}"
      end
    end
end
