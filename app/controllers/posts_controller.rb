class PostsController < ApplicationController

  def create
    @post = Post.new(params[:post])
    @talk = @post.talk
    @post.user = current_user

    @talk.mark_visited(current_user.id)

    if @post.save
      flash[:current_post_id] = @post.id
      redirect_to talk_path(@post.talk, :anchor => "current"),
        notice: I18n.t('.posts_controller.post_successfully_created')
    else
      flash[:error] = I18n.t("posts_controller.post_create_failed")
      redirect_to talk_path(@post.talk)
    end
  end

  def update
    with_owner_only(Post.find(params[:id])) do |post|
      @post = post

      if @post.update_attributes(params[:post])
        flash[:current_post_id] = @post.id
        redirect_to talk_path(@post.talk, :anchor => "current"),
          notice: I18n.t("posts_controller.post_successfully_updated")
      else
        flash[:error] = I18n.t("posts_controller.post_update_failed")
        redirect_to talk_path(@post.talk)
      end
    end
  end

  def destroy
    with_owner_only(Post.find(params[:id])) do |post|
      post.destroy

      redirect_to talk_path(post.talk),
        notice: 'Post was successfully deleted.',
        anchor: 'last'
    end
  end

  def edit
    with_owner_only(Post.find(params[:id])) do |post|
      @post = post
      @talk = post.talk

      respond_to do |format|
        format.js
      end
    end
  end
end
