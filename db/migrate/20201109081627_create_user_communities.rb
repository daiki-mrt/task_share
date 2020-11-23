class CreateUserCommunities < ActiveRecord::Migration[6.0]
  def change
    create_table :user_communities do |t|
      t.references :user, foreign_key: true
      t.references :community, foreign_key: true
      t.timestamps
      t.index [:user_id, :community_id], unique: true
    end
  end
end
