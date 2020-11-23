class AnswersController < ApplicationController
  def create
    @answer = Answer.new(answer_params)
    redirect_to request.referer if @answer.save
  end

  private

  def answer_params
    params.require(:answer).permit(:text).merge(user_id: current_user.id, question_id: params[:question_id])
  end
end
