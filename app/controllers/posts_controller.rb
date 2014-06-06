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
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    if author_exists = User.where(:user_id => @post.user_id).first
  	  if current_user == author_exists
      else
        redirect_to discussions_path
      end
    else
      redirect_to discussions_path
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.discussion_id = params[:post][:discussion_id]
    if @post.save
      redirect_to discussion_url(@post.discussion_id), notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if current_user == User.find(@post.user_id)
      if @post.update(post_params)
        redirect_to discussion_url(@post.discussion_id), notice: 'Post was successfully updated.'
      else
        render :edit
      end
    else
      redirect_to discussion_url(@post.discussion_id)
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    if current_user == User.find(@post.user_id)
      @post.destroy
      redirect_to discussions_url, notice: 'Post was successfully destroyed.'
    else
      redirect_to discussions_url
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:content, :user_id)
    end
end
