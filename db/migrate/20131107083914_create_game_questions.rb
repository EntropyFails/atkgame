class CreateGameQuestions < ActiveRecord::Migration
  def change
    create_table :game_questions do |t|
      t.integer :game_id
      t.integer :question_number
      t.string :text
      t.string :answer

      t.timestamps
    end
  end
end
