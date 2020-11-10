class QuestionsController < ApplicationController
  before_action :set_community
  before_action :set_questions
  
  def index
    set_community
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to community_questions_path(@community)
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
    params.require(:question).permit(:title, :content).merge(user_id: current_user.id, community_id: params[:community_id])
  end
end
