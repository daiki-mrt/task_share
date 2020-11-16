class QuestionsController < ApplicationController
  before_action :set_community
  before_action :set_question, only: [:show, :edit, :update, :destroy, :resolve]
  before_action :move_to_index, except: [:index, :show]
  before_action :configure_author, only: [:edit, :update, :resolve]
  before_action :answer_new, only: [:show, :create, :update, :resolve]
  before_action :set_answers, only: [:show, :update, :resolve]
  
  
  def index
    @questions = @community.questions.includes(:user).order("created_at DESC")
    # サイドバー用データ取得
    @joined_users = @community.joined_users
    joined_user_ids = @joined_users.pluck(:id)
    @tasks = Task.where(user_id: joined_user_ids).order("created_at DESC")
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
    # サイドバー用データ取得
    @joined_users = @community.joined_users
    joined_user_ids = @joined_users.pluck(:id)
    @tasks = Task.where(user_id: joined_user_ids).order("created_at DESC")
    @questions = @community.questions
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to community_question_path(@community, @question)
    elsif
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to community_questions_path(@community)
  end

  # 受付→解決済みに変更する
  def resolve
    if @question.state
      @question.update(state: 0)
      redirect_to community_question_path(@community)
    else
      @question.update(state: 1)
      redirect_to community_question_path(@community)
    end
  end

  private
  def set_community
    @community = Community.find(params[:community_id])
  end

  def set_question
    @question = Question.find(params[:id])
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
      redirect_to community_question_path(@community, @question)
    end
  end

  def answer_new
    @answer = Answer.new
  end

  def set_answers
    set_question
    @answers = @question.answers.includes(:user).order("created_at DESC")
  end
end