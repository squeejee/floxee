class PeopleController < ApplicationController
  before_filter :find_person, :only => [:show, :tweetstream, :follow]
  before_filter :login_required, :only => [:follow, :follow_all]
  
  def index
    @page_title = t('people')
    @people = Person.paginate(params)
    @reverse = params[:reverse]
    @sort_attribute = params[:sort]
  end
  

  def show
    if @person.tweets?
      @page_title = t('person_is_on_twitter', :name => @person.display_name)
      @tweets = TwitterStatus.paginate(params.merge({:screen_names => @person.screen_name}))
      
    else
      @page_title = t('person_is_on_not_twitter', :name => @person.display_name)
    end
   
  end
  
  def follow
    if @person and @person.tweets?
      twitter_response = JSON.parse(current_user.twitter.post("http://twitter.com/friendships/create/#{@person.screen_name}.json"))
      flash[:notice] = t('you_are_now_following', :name => @person.screen_name)
    end
  end
  
  def follow_all
    render :text => 'foobar'
  end
  
  protected
    def find_person
      @person = Person.get(params[:id])
    end

end
