class GoodsController < ApplicationController
  def create
    good = Good.new(user_id: current_user.id, question_id: params[:question_id])
    good.save
    redirect_to request.referer
  end

  def destroy
    good = Good.find_by(user_id: current_user.id, question_id: params[:question_id])
    good.destroy
    redirect_to request.referer
  end
end
