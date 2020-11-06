class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :relationships do |t|
      t.integer :following_id #フォロー側のユーザー(主語)
      t.integer :follower_id #被フォロー
      t.timestamps
      t.index [:following_id, :follower_id], unique: true
    end
  end
end
