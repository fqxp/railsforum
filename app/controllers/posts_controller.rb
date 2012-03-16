class PostsController < ApplicationController

  def create
    @post = Post.new(params[:post])
    @talk = @post.talk
    @post.user = current_user

    TalkVisit.mark_visited(@talk.id, current_user.id)

    if @post.save
      flash[:current_post_id] = @post.id
      redirect_to talk_path(@post.talk)+'#current',
        notice: I18n.t('.posts_controller.post_successfully_created')
    else
      redirect_to talk_path(@post.talk)
    end
  end

  def update
    with_owner_only(Post.find(params[:id])) do |post|
      @post = post
      if false or @post.update_attributes(params[:post])
        flash[:current_post_id] = @post.id
        redirect_to talk_path(@post.talk),
          notice: 'Post was successfully updated.',
          anchor: 'current'
      else
        redirect_to talk_path(@post.talk), error: 'Post could not be updated.'
      end
    end
  end

  def destroy
    with_owner_only(Post.find(params[:id])) do |post|
      post.destroy

      redirect_to talk_path(@post.talk),
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
