class PeopleController < ApplicationController
  before_filter :find_person, :only => [:show, :tweetstream, :follow]
  before_filter :ensure_current_person_url, :only => :show
  before_filter :login_required, :only => [:follow, :follow_all]
  
  def index
    @page_title = t('people')
    opts = { :page => params[:page], :order => 'users.followers_count DESC', :include => :user }
    opts[:order] = params[:sort] unless params[:sort].blank?
    opts[:conditions] = ["concat(people.first_name, ' ', people.last_name) like ? or concat(people.nickname, ' ', people.last_name) like ?", "%#{params[:q]}%","%#{params[:q]}%"] unless params[:q].blank?
    @people = Person.paginate opts
  end
  

  def show
    if @person.tweets?
      @page_title = t('person_is_on_twitter', :name => @person.display_name)
    else
      @page_title = t('person_is_on_not_twitter', :name => @person.display_name)
    end
   
  end
  
  def follow
    if @person and @person.tweets?
      begin
        twitter_response = current_user.twitter.post("http://twitter.com/friendships/create/#{@person.screen_name}.json")
        flash[:notice] = t('you_are_now_following', :name => @person.screen_name)
      rescue Exception => e
        flash[:notice] = e.message
      end
    end
    redirect_to people_path
  end
  
  def follow_all
    render :text => 'foobar'
    redirect_to people_path
  end
  
  protected
    def find_person
      @person = Person.find(params[:id])
      opts = {:page => params[:page], :order => 'statuses.id DESC', :include => :user}
      opts[:conditions] = ["statuses.text like ?", "%#{params[:q]}%"] unless params[:q].blank?
      @tweets = @person.user.statuses.paginate opts
    end
    
    def ensure_current_person_url
      redirect_to @person, :status => :moved_permanently if @person.has_better_id?
    end
    

end
