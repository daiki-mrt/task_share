class QuestionsController < ApplicationController
  before_action :set_community
  before_action :set_questions, only: [:index, :destroy]
  before_action :move_to_index, except: [:index, :show]
  before_action :configure_author, only: [:edit, :update]
  
  def index
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
    set_question
  end

  def edit
    set_question
  end

  def update
    set_question
    if @question.update(question_params)
      redirect_to community_question_path(@community, @question)
    elsif
      render :edit
    end
  end

  def destroy
    set_question
    @question.destroy
    redirect_to community_questions_path(@community)
  end


  private
  def set_community
    @community = Community.find(params[:community_id])
  end

  def set_question
    @question = Question.find(params[:id])
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

  def configure_author
    set_question
    if current_user.id != @question.user.id
      redirect_to community_questions_path(@community)
    end
  end
end