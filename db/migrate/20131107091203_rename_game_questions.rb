class RenameGameQuestions < ActiveRecord::Migration
  def change
    rename_table :game_questions, :questions
  end
end
