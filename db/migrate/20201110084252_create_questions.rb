class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.references :user, foreign_key: true
      t.references :community, foreign_key: true
      t.string :title, null: false
      t.text :content
      t.boolean :state
      t.timestamps
    end
  end
end
