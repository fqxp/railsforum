class UsersController < ApplicationController
  before_filter :authorize_by_id, :only => [:edit, :create, :update, :destroy]
  before_filter :admin_only, :only => [:index, :new]

  def index
    @users = User.order(:username)
  end

  def new
    @user = User.new()
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to users_url, notice: I18n.t('.users.controller.created_user', :username => @user.username)
    else
      render action: "new"
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      return_to root_url, notice: I18n.t('.users.controller.settings_saved')
    else
      render action: "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_url
  end

private
  def authorize_by_id
    unless current_user.is_admin or params[:id].to_i == current_user[:id]
      redirect_to new_user_session_url, :notice => I18n.t('.users.controller.permission_denied')
    end
  end
end
