class Admin::UsersController < ApplicationController
  
  before_filter :find_user, :only => [:edit, :update, :destroy, :sync]
  before_filter :login_required
  
  def index    
    @page_title = t('user_admin')
    opts = { :page => params[:page], :order => 'users.followers_count DESC', :per_page => params[:per_page] }
    opts[:order] = params[:sort] unless params[:sort].blank?
    opts[:conditions] = ["users.name like ? or users.description like ? ", "%#{params[:q]}%","%#{params[:q]}%"] unless params[:q].blank?
    @users = User.paginate opts
    
    render :layout => false if request.xhr?
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "#{@user.display_name} was successfully added."
      redirect_to(admin_people_path)
    else
      flash.now[:error] = 'Oops there was a problem saving this user'
      render :action => "edit" 
    end
    
  end
  
  def edit

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  def sync
    @user.sync
    flash[:notice] = "Manually synced #{@user.name}"
    redirect_to edit_admin_user_path(@user)
  end
  
  # PUT /admin/people/chris-lee
  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = 'user was successfully updated.'
      redirect_to(admin_users_path)
    else
      flash.now[:error] = 'Oops there was a problem saving this user'
      render :action => "edit" 
    end
  end
  
  # DELETE /admin/people/chris-lee
  def destroy
    @user.destroy
    
    flash[:notice] = "#{@user.display_name} was deleted."
    redirect_to(admin_users_url) 
  end
  
  protected
    def find_user
      @user = User.find(params[:id])
    end
end