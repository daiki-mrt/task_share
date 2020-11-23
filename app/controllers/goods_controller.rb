class GoodsController < ApplicationController
  before_action :question_params

  def create
    good = Good.new(user_id: current_user.id, question_id: params[:question_id])
    good.save
  end

  def destroy
    good = Good.find_by(user_id: current_user.id, question_id: params[:question_id])
    good.destroy
  end

  def question_params
    @question = Question.find(params[:question_id])
  end
end
