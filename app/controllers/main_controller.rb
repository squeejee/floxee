class MainController < ApplicationController
  
  def index
    @page_title = t('home_title')
    @tweets = TwitterStatus.paginate(params)
  end
  
  def tweetstream
    @page_title = t('tweetstream')
    @tweets = TwitterStatus.paginate(params)
  end
  
  def stats
    @most_followed = Person.all.sort_by{|p| p.followers_count.to_i}.reverse[0..4]
    @most_active = Person.all.sort_by{|p| p.statuses_count.to_i}.reverse[0..4]
    @most_new_seven_days = Person.most_followers_last_seven_days
    @most_new_thirty_days = Person.most_followers_last_thirty_days
  end
  
  protected

end
