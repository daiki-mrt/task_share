class CreateChats < ActiveRecord::Migration[6.0]
  def change
    create_table :chats do |t|
      t.references :user, foreign_key: true
      t.references :community, foreign_key: true
      t.text :text, null: false
      t.timestamps
    end
  end
end
