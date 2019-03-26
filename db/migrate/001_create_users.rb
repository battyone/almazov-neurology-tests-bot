class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, force: true do |t|
      t.integer :uid
    end

    create_table :tests do |t|
      t.integer :score
      t.boolean :is_finished, default: false, null: false
      t.string :current_question
      t.integer :current_question_index

      t.integer :user_id
    end

    add_index :tests, :user_id
  end
end
