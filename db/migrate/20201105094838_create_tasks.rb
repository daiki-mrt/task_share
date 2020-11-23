class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :text
      t.boolean :state, default: false, null: false
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
