class Stats < ActiveRecord::Base
  belongs_to :user
  
  def sync
    return if self.user.nil? or self.user.screen_name.blank?
    
    # update TwitterCounter stats: http://twittercounter.com/api/?username=pengwynn&output=json&results=365
    info = JSON.parse(Net::HTTP.get(URI.parse("http://twittercounter.com/api/?username=#{self.user.screen_name}&output=json&results=365&#{Time.now.to_i}")))
    unless info.blank?
      info.delete('user_id')
      info.keys.each do |key|
        self[key] = info[key] if self.respond_to?(key)
      end
    
      unless info['followersperdate'].blank?
        info['followersperdate'].map{|date, total| [date.gsub("date",""), total]}.each do |date, total|
          self.user.daily_stats.find_or_create_by_report_date_and_followers_count(date, total)
        end
        
        today = self.user.daily_stats.maximum(:followers_count, :conditions => ["report_date > ? ", 2.days.ago]).to_i  
        if today > 0
          seven_days_ago = self.user.daily_stats.maximum(:followers_count, :conditions => ["report_date < ? ", 7.days.ago]).to_i
          thirty_days_ago = self.user.daily_stats.maximum(:followers_count, :conditions => ["report_date < ? ", 30.days.ago]).to_i
          
          self.followers_change_last_seven_days = (today - seven_days_ago)
          self.followers_change_last_thirty_days = (today - thirty_days_ago)
        end
      end
    end
    
    # update FollowCost stats: http://followcost.com/pengwynn.json
    info = JSON.parse(Net::HTTP.get(URI.parse("http://followcost.com/#{self.user.screen_name}.json")))
    unless info.blank?
      info.keys.each do |key|
        self[key] = info[key] if self.respond_to?(key)
      end
    end
    self.save
  end
end
