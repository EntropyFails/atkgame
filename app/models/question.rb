class Question < ActiveRecord::Base
  attr_accessible :answer, :game_id, :question_number, :text
  belongs_to :game

  has_many :answers
  has_many :users, :through => :answers
  accepts_nested_attributes_for :answers, :users
  
  scope :numerical_order, order('question_number ASC')
  scope :descending_order, order('question_number DESC')
  before_create :increment_question_number

  def correct_responses
    self.answers.where(:response => self.answer)
  end
  
  def incorrect_responses
    self.answers.where("response != ?", self.answer)
  end

  def t_responses
    self.answers.where(:response => "T")
  end
  
  def f_responses
    self.answers.where(:response => "F")
  end  
 
  def increment_question_number
    current_max = self.game.questions.maximum(:question_number)
    if current_max.blank?
        self.question_number = 0
    else
        self.question_number = current_max + 1
    end
  end
end
