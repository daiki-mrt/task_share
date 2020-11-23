class ChangeColumnToQuestions < ActiveRecord::Migration[6.0]
  def change
    change_column_default :questions, :state, from: nil, to: false
  end
end
