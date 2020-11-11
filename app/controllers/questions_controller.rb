class QuestionsController < ApplicationController
  before_action :set_community
  before_action :set_questions
  before_action :move_to_index, only: [:new, :create]
  
  def index
    set_community
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to community_question_path(@community, @question)
    else
      render :new
    end
  end

  def show
    @question = Question.find(params[:id])
  end

  private
  def set_community
    @community = Community.find(params[:community_id])
  end

  def set_questions
    @questions = @community.questions.includes(:user)
  end

  def question_params
    params.require(:question).permit(:title, :content, :image).merge(user_id: current_user.id, community_id: params[:community_id])
  end

  def move_to_index
    set_community
    if !current_user.already_joined?(@community)
      redirect_to community_questions_path(@community)
    end
  end
end