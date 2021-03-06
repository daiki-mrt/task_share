class CommunitiesController < ApplicationController
  before_action :set_community, only: [:edit, :update, :show, :join]
  before_action :move_to_index, only: [:edit, :update]

  def index
    @search_params = community_search_params
    @communities = Community.search(@search_params)
  end

  def new
    @community = Community.new
  end

  def create
    @community = Community.new(community_params)
    if @community.save
      user_community = @community.user_communities.new(user_id: current_user.id)
      user_community.save
      redirect_to community_path(@community)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @community.update(community_params)
      redirect_to community_path(@community)
    else
      render :edit
    end
  end

  def show
    # 参加ユーザー
    @joined_users = @community.joined_users.includes(profile: { image_attachment: :blob })
    # 参加ユーザーのタスク(サイドバー)
    @tasks = Task.user_is(@joined_users.pluck(:id))
    # うち未完了のタスク(一覧表示)
    @remain_tasks = @tasks.includes(user: { profile: { image_attachment: :blob } }).not_completed.order("created_at DESC")
    @questions = Question.where(community_id: @community.id)
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
    redirect_to communities_path if @community.user.id != current_user.id
  end

  def community_search_params
    params.fetch(:search, {}).permit(:text, :category_id)
  end
end
