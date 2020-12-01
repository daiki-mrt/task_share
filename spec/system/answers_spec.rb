require 'rails_helper'

RSpec.describe 'Answers', type: :system do
  include LoginSupport

  describe "質問にコメントする" do
    before "ログインと質問登録" do
      @user = create(:user)
      user_profile = create(:profile, user_id: @user.id)
      @community = create(:community, user_id: @user.id)
      UserCommunity.create(user_id: @user.id, community_id: @community.id)
      sign_in_as @user
      @question = create(:question, user_id: @user.id, community_id: @community.id)
    end

end
