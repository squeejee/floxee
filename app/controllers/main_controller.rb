class MainController < ApplicationController
  
  def index
    @page_title = t('home_title')
    opts = {:page => params[:page], :order => 'statuses.id DESC', :include => :user}
    @tweets = Status.paginate opts
  end
  
  def tweetstream
    @page_title = t('tweetstream')
    opts = {:page => params[:page], :order => 'statuses.id DESC', :include => :user}
    opts[:per_page] ||= 10
    opts[:conditions] = ["statuses.text like ?", "%#{params[:q]}%"] unless params[:q].blank?
    @tweets = Status.paginate opts
  end
  
  def stats
    @most_followed = User.all(:order => 'users.followers_count desc', :limit => 5 )
    @most_active = User.all(:order => 'users.statuses_count desc', :limit => 5) 
    
    @most_new_seven_days = User.all(:include => :stats, :order => 'stats.followers_change_last_seven_days desc', :limit => 5).map{|u| [u, u.stats.followers_change_last_seven_days]}
    @most_new_thirty_days = User.all(:include => :stats, :order => 'stats.followers_change_last_thirty_days desc', :limit => 5).map{|u| [u, u.stats.followers_change_last_thirty_days]}
  end

  
  protected

end
