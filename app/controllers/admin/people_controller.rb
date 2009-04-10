class Admin::PeopleController < ApplicationController
  before_filter :login_required    
  before_filter :find_person, :only => [:edit, :update, :destroy, :confirm_destroy]
  before_filter :ensure_current_person_url, :only => :show

  
  def index    
    @page_title = t('people_admin')
    opts = { :page => params[:page], :order => 'users.followers_count DESC', :include => :user }
    opts[:order] = params[:sort] unless params[:sort].blank?
    opts[:conditions] = ["concat(people.first_name, ' ', people.last_name) like ? or concat(people.nickname, ' ', people.last_name) like ?", "%#{params[:q]}%","%#{params[:q]}%"] unless params[:q].blank?
    @people = Person.paginate opts
    
    render :layout => false if request.xhr?
  end
  
  def new
    @person = Person.new
  end
  
  def create
    @person = Person.new(params[:person])
    if @person.save
      flash[:notice] = "#{@person.display_name} was successfully added."
      redirect_to(admin_people_path)
    else
      flash.now[:error] = 'Oops there was a problem saving this person'
      render :action => "new" 
    end
    
  end
  
  def edit

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person }
    end
  end
  
  # PUT /admin/people/chris-lee
  def update
    if @person.update_attributes(params[:person])
      flash[:notice] = 'Person was successfully updated.'
      redirect_to(admin_people_path)
    else
      flash.now[:error] = 'Oops there was a problem saving this person'
      render :action => "edit" 
    end
  end
  
  # DELETE /admin/people/chris-lee
  def destroy
    @person.destroy
    
    flash[:notice] = "#{@person.display_name} was deleted."
    redirect_to(admin_people_url) 
  end
  
  # GET /admin/people/chris-lee/confirm_destroy
  def confirm_destroy
    
  end
  
  protected
    def find_person
      @person = Person.find(params[:id])
    end
    
    def ensure_current_person_url
      redirect_to @person, :status => :moved_permanently if @person.has_better_id?
    end
    
end
