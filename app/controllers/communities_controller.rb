class CommunitiesController < ApplicationController
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

  private
  def community_params
    params.require(:community).permit(:name, :category_id, :text).merge(user_id: current_user.id)
  end
end
