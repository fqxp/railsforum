class TalksController < ApplicationController
  def show
    @talk = Talk.find(params[:id].to_i)
    @posts = Post.where(:talk_id => @talk.id).order('created_at')
    @current_category = @talk.category
    @post = Post.new(:talk_id => @talk.id)

    @talk.mark_visited(current_user.id)
  end

  def new
    if params.has_key? :category_id
      @talk = Talk.new(:category_id => params[:category_id])
    else
      @talk = Talk.new(:category_id => nil)
    end

    @post = Post.new
  end

  def create
    @post = Post.new(params[:post])
    @talk = Talk.new(params[:talk])
    @post.user = @talk.user = current_user

    begin
      @post.talk_id = -1
      # Perform validation for both models in any case
      talk_valid = @talk.valid?
      post_valid = @post.valid?
      if talk_valid and post_valid
        @talk.transaction do
          @talk.save!
          @post.talk_id = @talk.id
          @post.save!

          redirect_to @talk, notice: I18n.t('.talk_success_msg')
        end
      else
        render action: "new"
      end
    end
  end
end
