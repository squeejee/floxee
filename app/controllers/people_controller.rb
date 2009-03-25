class PeopleController < ApplicationController
  before_filter :find_person, :only => [:show, :tweetstream]
  
  def index
    @page_title = t('people')
    @people = Person.paginate(params)
    
  end
  

  def show
    if @person.tweets?
      @page_title = t('person_is_on_twitter', :name => @person.display_name)
    else
      @page_title = t('person_is_on_not_twitter', :name => @person.display_name)
    end
   
  end
  
  protected
    def find_person
      @person = Person.get(params[:id])
      @tweets = TwitterStatus.paginate(params.merge({:screen_names => @person.screen_name}))
      
    end

end
