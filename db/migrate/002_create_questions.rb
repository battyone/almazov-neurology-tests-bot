class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.string :text, null: false
      t.string :answer1, null: false
      t.string :answer2, null: false
      t.string :answer3, null: false
      t.string :answer4, null: false
      t.string :right_answer, null: false

      t.index :text, unique: true
    end

    create_join_table :questions, :tests do |t|
      t.index [:question_id, :test_id], unique: true
    end
  end
end
