class CommunitiesController < ApplicationController
  before_action :set_community, only: [:edit, :update, :show, :join]
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
    @tasks = Task.includes(:user)
  end
  
  def join
    user_community = @community.user_communities.new(user_id: current_user.id)
    if user_community.save
      redirect_to community_path(@community)
    else
      render :show
    end
  end

  def exit
    user_community = UserCommunity.find_by(user_id: current_user.id, community_id: params[:id])
    if user_community.destroy
      redirect_to community_path(params[:id])
    else
      render :show
    end
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
