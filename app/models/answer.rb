class Answer < ActiveRecord::Base
  attr_accessible :question_id, :response, :user_id

  belongs_to :question
  belongs_to :user
  
  validates_uniqueness_of :user_id, :scope => :question_id
  validates :response, inclusion: { in: %w(T F),
  message: "%{value} is not a valid answer" }

end
