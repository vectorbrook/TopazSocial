class ForumPostsController < ApplicationController

  before_action :set_forum  #, only: [:index, :new, :create, :edit, :update]
  before_action :set_forum_topic #, only: [:show, :edit, :update, :destroy]
  before_action :set_forum_post, only: [:show, :edit, :update, :destroy, :addto_service]

  before_action :require_emp_prospect, :only => [:new, :create]
  before_action :require_created_by, :only => [:edit, :update, :destroy]
 
  def require_emp_prospect
    if !(current_user and (current_user.role.include?("employee") || current_user.role.include?("prospect") || current_user.role.include?("contact")))
      flash[:notice] = "You need to be either Employee or Prospect or Contact."
      redirect_to root_url
    end
  end
  
  def require_created_by
    if !((@forum_post and @forum_post.user_id == current_user.id) || current_user.role.include?("admin"))
      flash[:notice] = "You are not authorized."
      redirect_to root_url
    end
  end
  
  # GET /forum_posts
  # GET /forum_posts.json
  def index
    @posts = @forum_topic.forum_posts.order_by('created_at DESC').page params[:page]
    @forum_topic.hits = 0 if @forum_topic.hits == nil
    @forum_topic.hits = @forum_topic.hits + 1
    @forum_topic.save
  end

  # GET /forum_posts/1
  # GET /forum_posts/1.json
  def show
  end

  # GET /forum_posts/new
  def new
    @forum_post = @forum_topic.forum_posts.new
  end

  # GET /forum_posts/1/edit
  def edit
    p "edit post"
  end

  # POST /forum_posts
  # POST /forum_posts.json
  def create
    p "forum_post create"
    @forum_post = @forum_topic.forum_posts.new(forum_post_params)
    @forum_post.user_id = current_user.id
    respond_to do |format|
      if @forum_post.save
        format.html { redirect_to forum_forum_topics_path(@forum), notice: 'Forum post was successfully created.' }
        #post = {"_id" => @forum_post.id.to_s, "body" => @forum_post.body, "description" => @forum_post.description, "forum_id" => @forum.id.to_s, "forum_topic_id" => @forum_topic.id.to_s}

        #format.json { render json: post }
        format.json { render action: 'show', status: :created, location: @forum_post }
        @forum_topic.last_post_created_at = Time.now
        @forum_topic.last_post_created_by = current_user.email
        @forum_topic.save
        @forum.last_post_created_at = Time.now
        @forum.last_post_created_by = current_user.email
        @forum.save
      else
        format.html { render action: 'new' }
        format.json { render json: @forum_post.errors, status: :unprocessable_entity }
      end

    end
  end

  # PATCH/PUT /forum_posts/1
  # PATCH/PUT /forum_posts/1.json
  def update
    respond_to do |format|
      if @forum_post.update(forum_post_params)
        format.html { redirect_to forum_forum_topics_path(@forum), notice: 'Forum post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @forum_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forum_posts/1
  # DELETE /forum_posts/1.json
  def destroy
    @forum_post.destroy
    respond_to do |format|
      format.html { redirect_to forum_forum_topics_path(@forum) }
      format.json { head :no_content }
    end
  end
  
  def addto_service
      @service_case = @forum_post.create_service_case(:name => @forum_post.body, :description => @forum_post.description, :status => @forum_post.status)
      @service_case.try(:save!)
      respond_to do |format|
        format.html { redirect_to forum_forum_topics_path(@forum), notice: 'service cases was successfully created.' }
        format.json { head :no_content }
      end  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forum_topic
      @forum_topic = @forum.forum_topics.where(:id => params[:forum_topic_id]).first
    end

    def set_forum
      @forum = Forum.where(:id => params[:forum_id]).first
    end

    def set_forum_post
      @forum_post = @forum_topic.forum_posts.where(:id => params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def forum_post_params
      params.require(:forum_post).permit(:body, :description, :user_id, :status)
    end
end
