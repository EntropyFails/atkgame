class AddVictoriesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :score, :integer, default: 0
    add_column :users, :victories, :integer, default: 0
    add_column :users, :correct_answers, :integer, default: 0
  end
end
