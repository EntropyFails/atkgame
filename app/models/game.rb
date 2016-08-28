class Game < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :questions
  
  has_many :players
  has_many :users, :through => :players
  accepts_nested_attributes_for :players, :users
  #scope :current_question, questions.descending_order.first
  
  def current_question
    questions.descending_order.first
  end
  
  def correct_responses
    q = self.current_question
    q.answers.where(:response => q.answer)
  end
  
  def incorrect_responses
    q = self.current_question
    q.answers.where("response != ?", q.answer)
  end


  def non_responsive_players
    q = self.current_question    
    self.players.where("user_id NOT IN (?)", q.answers.map(&:user_id))
  end
  
  def self.current_game
    Game.where(:status => ["Pending", "Started"]).first
  end
  
  def is_alive(user)
    
  end
  
  
  def start
    self.status = "Started"
    self.save
  end

  def end
    q = self.current_question
    if q.blank? || q.status != "processed"
      return true
    end
    self.status = "Ended"
    self.save

    self.players.each do |p|
      p.user.update_correct_answers!
      p.user.update_victories!
    end
  end
  
  
  def end_round
    q = self.current_question
    q.status = "processed"
    q.save
    if q.answer == "undefined"
        return true
    end
    self.incorrect_responses.each do |wrong|
        player = wrong.user.players.where(:game_id => self.id).first
        player.status = "dead"
        player.save
    end
    self.non_responsive_players.each do |idle|
        idle.status = "dead"
        idle.save
    end
  end
  
  before_create :starting_state
  validate :ensure_one_active, :on => :create

  private
    def starting_state
        self.status = "Pending"
    end  
    def ensure_one_active
        if Game.where(:status => ["Pending", "Started"]).count > 0
            errors.add(:game, "has another game pending or started")
        end
    end
end
