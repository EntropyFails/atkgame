class AddStatusToQuestion < ActiveRecord::Migration
  def change
        add_column :questions, :status, :string, default: "current"
  end
end
