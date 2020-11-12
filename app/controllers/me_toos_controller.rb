class MeToosController < ApplicationController
  def create
    me_too = MeToo.new(user_id: current_user.id, question_id: params[:question_id])
    me_too.save
    redirect_to request.referer
  end

  def destroy
    me_too = MeToo.find_by(user_id: current_user.id, question_id: params[:question_id])
    me_too.destroy
    redirect_to request.referer
  end
end
