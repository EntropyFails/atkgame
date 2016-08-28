class AddRenameUserGame < ActiveRecord::Migration
  def change
    rename_table :user_games, :players
  end
end
