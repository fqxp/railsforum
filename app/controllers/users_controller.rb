class UsersController < ApplicationController
  before_filter :authorize_by_id, :only => [:edit, :create, :update, :destroy]
  before_filter :admin_only, :only => [:index, :new]
  
  # GET /users
  # GET /users.json
  def index
    @users = User.order(:username)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @user = User.new()

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
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
        format.html { return_to root_url, notice: I18n.t('.users.controller.settings_saved') }
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
  
private
  def authorize_by_id
    unless current_user.is_admin or params[:id].to_i == current_user[:id]
      redirect_to new_user_session_url, :notice => I18n.t('.users.controller.permission_denied')
    end
  end
end
