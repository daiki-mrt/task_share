class CommunitiesController < ApplicationController
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
    @community = Community.find(params[:id])
  end

  def update
    @community = Community.find(params[:id])
    if @community.update(community_params)
      redirect_to communities_path
    else
      render :edit
    end
  end

  private
  def community_params
    params.require(:community).permit(:name, :category_id, :text).merge(user_id: current_user.id)
  end

  def move_to_index
    community = Community.find(params[:id])
    if community.user.id != current_user.id
      redirect_to communities_path
    end
  end
end
