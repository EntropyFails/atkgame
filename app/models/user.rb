class User < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :name, uniqueness: true
  has_many :players
  has_many :games, :through => :players
  accepts_nested_attributes_for :players, :games

  has_many :answers
  has_many :questions, :through => :answers
  accepts_nested_attributes_for :answers, :questions  
  
  def is_alive(game)
    !self.players.where(:game_id => game.id, :status => "alive").blank?
  end

  def is_playing(game)
    !self.players.where(:game_id =>game.id).blank?
  end

  def in_current_game
    return false if Game.current_game.blank?
    !self.games.where(:id => Game.current_game.id).blank?
  end
  
  def answered_current_question?(game)
    return true if game.status == "Pending"
    return true if game.current_question.blank?
    !Answer.where(:question_id => game.current_question.id, :user_id => self.id).blank?
  end

  def update_correct_answers!
    answers = Answer.arel_table
    questions = Question.arel_table
    sql = answers.
      join(questions).
      on(questions[:id].eq(answers[:question_id])).
      where(answers[:user_id].eq(self.id)).
      where(questions[:answer].eq(answers[:response])).
      project(answers[:id].count)
    self.correct_answers = ActiveRecord::Base.connection.execute(sql.to_sql)[0]
    self.save
  end

  def update_victories!
    total_wins = 0
    total_score = 0
    Game.where(:status => "Ended").each do |g|
      if !g.current_question.blank? && g.current_question.answers.count == 2
        if !g.current_question.answers.where(:user_id => self.id).blank?
          if !g.current_question.correct_responses.where(:user_id => self.id).blank?
            total_wins += 1
            total_score += 4
          else
            total_score += 1
          end
        end
      end
    end

    self.score = total_score
    self.victories = total_wins
    self.save
  end
end

