class InteractionsController < ApplicationController

  before_filter :check_role, :only => [:index, :show, :new, :edit, :create, :update]

  # GET /interactions
  # GET /interactions.json
  def check_role
    is_admin? || is_support_manager? || is_support_agent? || is_social_media_manager? || is_community_manager?
  end

  def index
    @interactions = Interaction.all

    respond_to do |format|
      format.html # index.html.erb
      ##format.json { render json: @interactions }
    end
  end

  # GET /interactions/1
  # GET /interactions/1.json
  def show
    @interaction = Interaction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      #format.json { render json: @interaction }
    end
  end

  # GET /interactions/new
  # GET /interactions/new.json
  def new
    @interaction = Interaction.new

    respond_to do |format|
      format.html # new.html.erb
      #format.json { render json: @interaction }
    end
  end

  # GET /interactions/1/edit
  def edit
    @interaction = Interaction.find(params[:id])
    @name = Interaction::NameMapping[@interaction.context]
  end

  # POST /interactions
  # POST /interactions.json
  def create
    @interaction = Interaction.new(params[:interaction])
    @interaction.approved = true
    @interaction.approved_by = current_user.id
    @interaction.user_id = current_user.id

    respond_to do |format|
      if @interaction.save
        format.html { redirect_to session[:back_to] || root_url }
        #format.json { render json: @interaction, status: :created, location: @interaction }
      else
        format.html { redirect_to root_url, :notice => "Please try again."  }
        #format.json { render json: @interaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /interactions/1
  # PUT /interactions/1.json
  def update
    @interaction = Interaction.find(params[:id])
    @interaction.user_id = current_user.id
    @name = Interaction::NameMapping[@interaction.context]

    respond_to do |format|
      if @interaction.update_attributes(params[:interaction])
        format.html { redirect_to session[:back_to] || root_url, :notice => "#{@name} was successfully updated." }
        #format.json { head :no_content }
      else
        @name = Interaction::NameMapping[@interaction.context]
        format.html { render :action => "edit" }
        ##format.json { render json: @interaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /interactions/1
  # DELETE /interactions/1.json
  def destroy
    @interaction = Interaction.find(params[:id])
    @interaction.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      #format.json { head :no_content }
    end
  end

  def new_for_forum_topic
    @forum_topic = ForumTopic.find(params[:id])
    @interaction = Interaction.new(:context => "ForumTopic",:context_id => @forum_topic.id)
    @header = "Add a post for #{@forum_topic.title}"

    session[:back_to] = forum_forum_topic_path(@forum_topic.forum, @forum_topic)

    render :new
  end



end
