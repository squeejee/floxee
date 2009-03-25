class Admin::PeopleController < ApplicationController
    
  before_filter :find_person, :only => [:edit, :update, :destroy]
  before_filter :login_required
  
  def index    
    @page_title = t('people_admin')
    @people = Person.paginate(params)
    
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
      render :action => "edit" 
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
  
  protected
    def find_person
      @person = Person.get(params[:id])
    end
end
