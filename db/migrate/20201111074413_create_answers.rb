class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.text :text, null: false
      t.references :user, foreign_key: true
      t.references :question, foreign_key: true
      t.timestamps
    end
  end
end
