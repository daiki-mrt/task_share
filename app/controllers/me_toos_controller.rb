class MeToosController < ApplicationController
  before_action :question_params
  
  def create
    me_too = MeToo.new(user_id: current_user.id, question_id: params[:question_id])
    me_too.save
  end

  def destroy
    me_too = MeToo.find_by(user_id: current_user.id, question_id: params[:question_id])
    me_too.destroy
  end

  def question_params
    @question = Question.find(params[:question_id])
  end
end
