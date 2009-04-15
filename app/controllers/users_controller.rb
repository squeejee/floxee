class UsersController < ApplicationController
  before_filter :find_user, :only => [:show, :tweetstream, :follow]
  before_filter :ensure_friendly_id, :only => :show
  before_filter :login_required, :only => [:follow, :follow_all]
  
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = t('thanks_for_signing_up')
    else
      flash[:error]  = t('could_not_create_account_please_contact_admin')
      render :action => 'new'
    end
  end
  
  def index
    @page_title = t('users')
    opts = { :page => params[:page], :order => 'users.followers_count DESC', :per_page => params[:per_page] }
    opts[:order] = params[:sort] unless params[:sort].blank?
    opts[:conditions] = ["users.name like ? or users.description like ? ", "%#{params[:q]}%","%#{params[:q]}%"] unless params[:q].blank?
    @users = User.paginate opts
  end
  

  def show
    @page_title = t('user_is_on_twitter', :name => @user.name)
   
  end
  
  def tweetstream
    @page_title = t('users_tweetstream', :name => @user.name)
  end
  
  def follow
    if @user and @user.tweets?
      begin
        twitter_response = current_user.twitter.post("http://twitter.com/friendships/create/#{@user.screen_name}.json")
        flash[:notice] = t('you_are_now_following', :name => @user.screen_name)
      rescue Exception => e
        flash[:notice] = e.message
      end
    end
    redirect_to users_path
  end
  
  def follow_all
    render :text => 'foobar'
    redirect_to users_path
  end
  
  protected
    def find_user
      @user = User.find(params[:id])
      opts = {:page => params[:page], :order => 'statuses.id DESC', :include => :user}
      opts[:conditions] = ["statuses.text like ?", "%#{params[:q]}%"] unless params[:q].blank?
      @tweets = @user.statuses.paginate opts
    end
    
    def ensure_friendly_id
      redirect_to @user, :status => :moved_permanently if @user.has_better_id?
    end
    

end
