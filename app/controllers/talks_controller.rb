class TalksController < ApplicationController
  # GET /talks/1
  # GET /talks/1.json
  def show
    @talk = Talk.find(params[:id])
    @posts = Post.where(:talk_id => @talk.id).order('updated_at')
    @current_topic = @talk.topic

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @talk }
    end
  end

  # GET /talks/new
  # GET /talks/new.json
  def new
    @topic = Topic.find(params[:topic_id])
    @talk = Talk.new(:topic_id => params[:topic_id])
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @talk }
    end
  end

  # GET /talks/1/edit
  def edit
    @talk = Talk.find(params[:id])
    @post = Post.where(:talk_id => @talk.id).first
  end

  # POST /talks
  # POST /talks.json
  def create
    @talk = Talk.new(params[:talk])
    @topic = Topic.find(@talk.topic_id)
    @post = Post.new(params[:post])
    
    respond_to do |format|
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
            
            format.html { redirect_to @talk, notice: 'Talk was successfully created.' }
            format.json { render json: @talk, status: :created, location: @talk }
          end
        else
          format.html { render action: "new" }
          format.json { render json: @talk.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /talks/1
  # PUT /talks/1.json
  def update
    @talk = Talk.find(params[:id])

    respond_to do |format|
      if @talk.update_attributes(params[:talk])
        format.html { redirect_to @talk, notice: 'Talk was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @talk.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /talks/1
  # DELETE /talks/1.json
  def destroy
    @talk = Talk.find(params[:id])
    @talk.destroy

    respond_to do |format|
      format.html { redirect_to talks_url }
      format.json { head :ok }
    end
  end
end
