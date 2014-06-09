class DiscussionsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :edit, :create, :update, :destroy]
  before_action :set_discussion, only: [:show, :edit, :update, :destroy]
  
  # GET /discussions
  # GET /discussions.json
  def index
    @discussions = Discussion.all
  end

  # GET /discussions/1
  # GET /discussions/1.json
  def show
  end
  
  # GET /discussions/1/edit
  def edit
    @discussion = Discussion.find(params[:id])
  	@post = @discussion.posts.first
  	if author_exists = User.where(:id => @discussion.user_id).first
  	  if current_user == author_exists || current_user.try(:admin?) || current_user.try(:moderator?)
      else
        redirect_to discussion_path(@discussion)
      end
    else
      if current_user.try(:admin?) || current_user.try(:moderator?)
      else
        redirect_to discussion_path(@discussion)
      end
    end
  end

  # GET /discussions/new
  def new
    @discussion = Discussion.new
    @post = Post.new
  end

  # POST /discussions
  # POST /discussions.json
  def create
    @discussion = Discussion.new(discussion_params)
    @post = Post.new(post_params_on_discussion)
    if @discussion.save
      @post.discussion_id = @discussion.id
      @post.user_id = @discussion.user_id
      if @post.save
	    redirect_to discussion_path(@discussion), notice: 'Discussion was successfully created.'
      else
        render :new
      end
    else
      render :new
    end
  end

  # PATCH/PUT /discussions/1
  # PATCH/PUT /discussions/1.json
  def update
    if current_user == User.find(@discussion.user_id) || current_user.try(:admin?) || current_user.try(:moderator?)
      @post = @discussion.posts.first
      @post.edited_by_id = current_user.id
      if @discussion.update(discussion_params)
        if @post.update(post_params_on_discussion)
          redirect_to discussion_path(@discussion), notice: 'Discussion was successfully updated.'
        else
          render :edit
        end
      else
        render :edit
      end
    else
      redirect_to discussion_path(@discussion)
    end
  end
  
  
  # DELETE /discussions/1
  # DELETE /discussions/1.json
  def destroy
    forum = @discussion.forum
    if author_exists = User.where(:id => @discussion.user_id).first
      if current_user == author_exists || current_user.try(:admin?)
        @discussion.destroy
        redirect_to forum_path(@discussion.forum), notice: 'Discussion was successfully destroyed.'
      else
        redirect_to forum_path(@discussion.forum)
      end
    else
      if current_user.try(:admin?)
        @discussion.destroy
        redirect_to forum_path(@discussion.forum), notice: 'Discussion was successfully destroyed.'
      else
        redirect_to forum_path(@discussion.forum)
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_discussion
      @discussion = Discussion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def discussion_params
      params.require(:discussion).permit(:title, :user_id, :forum_id)
    end
    
    def post_params_on_discussion
      params.require(:post).permit(:content)
    end
end
