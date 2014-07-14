class ForumTopicsController < ApplicationController

  before_action :set_forum #, only: [:index, :new, :create, :edit, :update]
  before_action :set_forum_topic, only: [:show, :edit, :update, :destroy]
  before_action :require_emp_prospect, :only => [:new, :create]
  before_action :require_created_by, :only => [:edit, :update, :destroy]
 
  def require_emp_prospect
    if !(current_user and (current_user.role.include?("employee") || current_user.role.include?("prospect") || current_user.role.include?("contact")))
      flash[:notice] = "You need to be either Employee or Prospect or Contact."
      redirect_to root_url
    end
  end
  
  def require_created_by
    if !((@forum_topic and @forum_topic.user_id == current_user.id) || current_user.role.include?("admin"))
      flash[:notice] = "You are not authorized."
      redirect_to root_url
    end
  end
  
  # GET /forum_topics
  # GET /forum_topics.json
  def index
    @forum_topics = @forum.forum_topics.order_by('last_post_created_at DESC').page params[:page]
    @forum.hits = 0 if @forum.hits == nil
    @forum.hits = @forum.hits + 1
    @forum.save
  end

  # GET /forum_topics/1
  # GET /forum_topics/1.json
  def show
    @posts = @forum_topic.forum_posts.all
    p "aaaaaaaaaaaaaa"
    p @forum.id
    p @posts
  end

  # GET /forum_topics/new
  def new
    @forum_topic = @forum.forum_topics.new
  end

  # GET /forum_topics/1/edit
  def edit
  end

  # POST /forum_topics
  # POST /forum_topics.json
  def create
    @forum_topic = @forum.forum_topics.new(forum_topic_params)
    @forum_topic.user_id = current_user.id
    respond_to do |format|
      if @forum_topic.save
        format.html { redirect_to forums_path, notice: 'Forum topic was successfully created.' }
        format.json { render action: 'show', status: :created, location: @forum_topic }
      else
        format.html { render action: 'new' }
        format.json { render json: @forum_topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /forum_topics/1
  # PATCH/PUT /forum_topics/1.json
  def update
    respond_to do |format|
      if @forum_topic.update(forum_topic_params)
        format.html { redirect_to forum_forum_topics_path(@forum,@forum_topic), notice: 'Forum topic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @forum_topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forum_topics/1
  # DELETE /forum_topics/1.json
  def destroy
    @forum_topic.destroy
    respond_to do |format|
      format.html { redirect_to forum_forum_topics_path(@forum,@forum_topic) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forum_topic
      @forum_topic = @forum.forum_topics.where(:id => params[:id]).first
    end

    def set_forum
      @forum = Forum.where(:id => params[:forum_id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def forum_topic_params
      params.require(:forum_topic).permit(:title, :description, :user_id)
    end
end
