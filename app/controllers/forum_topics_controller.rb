class ForumTopicsController < ApplicationController
  
  #load_and_authorize_resource
  skip_authorization_check
  
  #before_filter :require_user , :only => ['new','create']
  #before_filter :require_admin , :only => ['edit','update','destroy','add_notification']
  # GET /forums
  # GET /forums.xml
  def index
    @forum = Forum.find(params[:forum_id])
    @topics = @forum.forum_topics
    #@interaction = Interaction.new(:context => "ForumTopic",:context_id => @topic.id)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @topics }
    end
  end

  # GET /topics/1
  # GET /topics/1.xml
  def show
    @forum = Forum.find params[:forum_id]
    @topic = @forum.forum_topics.find(params[:id]) #select {|topic| topic.id == (params[:id])}[0]
    @interactions = @topic.interactions
    @interaction = Interaction.new(:context => "ForumTopic",:context_id => @topic.id,:parent_context => "Forum", :parent_context_id => @forum.id)
    
    session[:back_to] = forum_forum_topic_path(@topic.forum, @topic)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/new
  # GET /topics/new.xml
  def new
    @forum = Forum.find params[:forum_id]
    @topic = ForumTopic.new(:forum => @forum)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/1/edit
  def edit    
    @forum = Forum.find params[:forum_id]
    @topic = ForumTopic.find(params[:id])
  end

  # POST /topics
  # POST /topics.xml
  def create
    @forum = Forum.find params[:forum_id]
    @topic = @forum.forum_topics.build(params[:forum_topic])
    @topic.user = current_user

    respond_to do |format|
      if @topic.save
        #format.html { redirect_to(@topic.forum) }
        format.html { redirect_to(:action => :index) }
        format.xml  { render :xml => @topic, :status => :created, :location => @topic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.xml
  def update
    @forum = Forum.find params[:forum_id]
    @topic = @forum.forum_topics.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:forum_topic])
        format.html { redirect_to(@topic.forum) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.xml
  def destroy
    @topic = ForumTopic.find(params[:id])
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to(topics_url) }
      format.xml  { head :ok }
    end
  end

  def approve
    @topic = ForumTopic.find(params[:id])
    @topic.save! if @topic.try(:approve,current_user)
    redirect_to pending_approvals_path
  end

   def disapprove
    @topic = ForumTopic.find(params[:id])
    @topic.save! if @topic.try(:disapprove,current_user)
    redirect_to pending_approvals_path
  end

  def enable
    @topic = ForumTopic.find(params[:id])
    @topic.save! if @topic.try(:enable,current_user)
    redirect_to @topic.forum
  end

   def disable
    @topic = ForumTopic.find(params[:id])
    @topic.save! if @topic.try(:disable,current_user)
    redirect_to @topic.forum
  end

  def add_notification
    if request.post?
      @topic = ForumTopic.find params[:topic_id]
      @topic.try(:add_notification,params[:commentary],current_user)
      redirect_to pending_forumrovals_path
    else
      @topic = ForumTopic.find params[:id]
      if @topic
        @notification = Notification.new(:parent_type => "ForumTopic" , :parent_id => @topic.id, :user => @topic.user )
      else
        redirect_to pending_approvals_path
      end
    end
  end

end

