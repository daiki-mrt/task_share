class CommunitiesController < ApplicationController
  before_action :set_community, only: [:edit, :update, :show]
  before_action :move_to_index, only: [:edit, :update]
  
  def index
    @communities = Community.all
  end

  def new
    @community = Community.new
  end

  def create
    @community = Community.new(community_params)
    if @community.save
      redirect_to communities_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @community.update(community_params)
      redirect_to communities_path
    else
      render :edit
    end
  end

  def show
  end
  
  private
  def community_params
    params.require(:community).permit(:name, :category_id, :text).merge(user_id: current_user.id)
  end

  def set_community
    @community = Community.find(params[:id])
  end

  def move_to_index
    if @community.user.id != current_user.id
      redirect_to communities_path
    end
  end
end
