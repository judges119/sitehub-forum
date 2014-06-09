class ForumsController < ApplicationController
  before_action :set_forum, only: [:show, :edit, :update, :destroy]

  # GET /forums
  # GET /forums.json
  def index
    @forums = Forum.all
    if current_user == User.first && !current_user.try(:admin?)
      current_user.update_attribute :admin, true
    end
  end

  # GET /forums/1
  # GET /forums/1.json
  def show
  end

  # GET /forums/new
  def new
    if current_user.try(:admin?) || current_user.try(:moderator?)
      @forum = Forum.new
    else
      render :index
    end
  end

  # GET /forums/1/edit
  def edit
  end

  # POST /forums
  # POST /forums.json
  def create
    if current_user.try(:admin?) || current_user.try(:moderator?)
      @forum = Forum.new(forum_params)
      if @forum.save
        redirect_to @forum, notice: 'Forum was successfully created.'
      else
        render :new
      end
    else
      render :index
    end
  end

  # PATCH/PUT /forums/1
  # PATCH/PUT /forums/1.json
  def update
    if current_user.try(:admin?) || current_user.try(:moderator?)
      if @forum.update(forum_params)
        redirect_to @forum, notice: 'Forum was successfully updated.'
      else
        render :edit
      end
    else
      render :index
    end
  end

  # DELETE /forums/1
  # DELETE /forums/1.json
  def destroy
    if current_user.try(:admin?)
      @forum.destroy
      redirect_to forums_url, notice: 'Forum was successfully destroyed.'
    else
      render :index
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forum
      @forum = Forum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def forum_params
      params.require(:forum).permit(:name, :description)
    end
end
