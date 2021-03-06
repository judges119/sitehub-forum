class PostsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :edit, :create, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    if params[:discussion] != nil
      if current_user != nil && !current_user.try(:banned?)
        @post = Post.new
      else
        redirect_to discussion_path(params[:discussion])
      end
    else
      redirect_to forums_path
    end
  end

  # GET /posts/1/edit
  def edit
    if current_user != nil && !current_user.try(:banned?)
      if author_exists = User.where(:id => @post.user_id).first
        if current_user == author_exists || current_user.try(:admin?) || current_user.try(:moderator?)
        else
          redirect_to discussion_path(@post.discussion_id)
        end
      else
        if current_user.try(:admin?) || current_user.try(:moderator?)
        else
          redirect_to discussion_path(@post.discussion_id)
        end
      end
    else
      redirect_to discussion_path(@post.discussion_id)
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    if current_user != nil && !current_user.try(:banned?)
      @post = Post.new(post_params)
      if @post.discussion_id != nil
        if @post.save
          redirect_to discussion_path(@post.discussion_id), notice: 'Post was successfully created.'
        else
          render :new
        end
      else
        render :new
      end
    else
      redirect_to discussion_path(params[:post][:discussion_id])
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if current_user != nil && !current_user.try(:banned?)
      if current_user == User.find(@post.user_id) || current_user.try(:admin?) || current_user.try(:moderator?)
        @post.edited_by_id = current_user.id
        if @post.update(post_params)
          redirect_to discussion_path(@post.discussion_id), notice: 'Post was successfully updated.'
        else
          render :edit
        end
      else
        redirect_to discussion_path(@post.discussion_id)
      end
    else
      redirect_to discussion_path(@post.discussion_id)
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    if current_user != nil && !current_user.try(:banned?)
      discussion = Discussion.where(:id => @post.discussion_id).first
      if author_exists = User.where(:id => @post.user_id).first
        if current_user == author_exists || current_user.try(:admin?)
          @post.destroy
          redirect_to discussion_path(discussion), notice: 'Post was successfully destroyed.'
        else
          redirect_to discussion_path(@post.discussion_id)
        end
      else
        if current_user.try(:admin?)
          @post.destroy
          redirect_to discussion_path(discussion), notice: 'Post was successfully destroyed.'
        else
          redirect_to discussion_path(@post.discussion_id)
        end
      end
    else
      redirect_to discussion_path(@post.discussion_id)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:content, :user_id, :discussion_id)
    end
end
