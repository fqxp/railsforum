class UsersController < ApplicationController
  skip_before_filter :authorize, :except => [:index, :show]
  before_filter :authorize_by_id, :only => [:edit, :create, :update, :destroy]
  
  # GET /users
  # GET /users.json
  def index
    @users = User.order(:username)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: I18n.t('.users.controller.created_user', :username => @user.username) }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to root_url, notice: I18n.t('.users.controller.settings_saved') }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end
  
  def edit_password
    @user = User.find(params[:id])
  end

  # PUT /users/1
  # PUT /users/1.json
  def update_password
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to edit_user_url(@user), notice: I18n.t('.users.controller.password_saved') }
        format.json { head :ok }
      else
        format.html { render action: :edit_password }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
private
  def authorize_by_id
    user = User.find(session[:user_id])
    unless user.is_admin or params[:id].to_i == session[:user_id]
      redirect_to login_url, :notice => I18n.t('.users.controller.permission_denied')
    end
  end
end
