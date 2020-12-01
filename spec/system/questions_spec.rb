require 'rails_helper'

RSpec.describe 'Communities', type: :system do
  include LoginSupport

  describe "質問を投稿する" do
    before "ユーザとコミュニティを作成し、ログイン" do
      @user = create(:user)
      user_profile = create(:profile, user_id: @user.id)
      @community = create(:community, user_id: @user.id)
      UserCommunity.create(user_id: @user.id, community_id: @community.id)
      sign_in_as @user
    end
    
    context "質問を投稿できるとき" do
      it "正しく情報を入力すると、保存できて質問詳細ページに遷移する" do
        visit "/communities/#{@community.id}"
        click_link '質問'
        expect(current_url).to include "/communities/#{@community.id}/questions"
        click_link '質問する'
        expect(current_url).to include "/communities/#{@community.id}/questions/new"
        expect { 
          fill_in 'question_title', with: '質問のタイトル'
          fill_in 'question_content', with: '質問の内容'
          click_on '投稿'
          expect(page).to have_content '質問のタイトル'
        }.to change { Question.count }.by(1)
      end
    end
    context "質問を投稿できないとき" do
      it "情報が正しくないと、保存できずに質問作成ページに遷移する" do
        visit "/communities/#{@community.id}"
        click_link '質問'
        expect(current_url).to include "/communities/#{@community.id}/questions"
        click_link '質問する'
        expect(current_url).to include "/communities/#{@community.id}/questions/new"
        expect { 
          click_on '投稿'
          expect(page).to have_css '.error-message'
        }.to change { Question.count }.by(0)
      end
    end
  end

end
