class PostsController < ApplicationController
  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @talk = Talk.find(params[:talk_id])
    @post = Post.new(:talk_id => @talk.id)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    with_owner_only(Post.find(params[:id])) do |post|
      @post = post
      respond_to do |format|
        format.html # edit.html.erb
        format.js
      end
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    @talk = @post.talk
    @post.user = current_user

    TalkVisit.mark_visited(@talk.id, current_user.id)   

    respond_to do |format|
      if @post.save
        flash[:current_post_id] = @post.id
        format.html { redirect_to talk_path(@post.talk)+'#current', 
                          notice: I18n.t('.posts_controller.post_successfully_created') }
        format.json { render json: @post, status: :created, location: @post }
        format.js
      else
        format.html { redirect_to talk_path(@post.talk) }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    with_owner_only(Post.find(params[:id])) do |post|
      @post = post
      respond_to do |format|
        if false or @post.update_attributes(params[:post])
          flash[:current_post_id] = @post.id
          format.html { redirect_to talk_path(@post.talk), 
                                    notice: 'Post was successfully updated.',
                                    anchor: 'current' }
          format.js
        else
          format.html { render action: "edit" }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    with_owner_only(Post.find(params[:id])) do |post|
      post.destroy
  
      respond_to do |format|
        format.html { redirect_to posts_url }
        format.json { head :ok }
      end
    end
  end
end
