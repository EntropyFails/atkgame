class Player < ActiveRecord::Base
    attr_accessible :game_id, :user_id, :status
    belongs_to :game
    belongs_to :user

    scope :alive, where('status = ?', "alive")
    scope :dead, where('status != ?', "alive")
    
    validates_uniqueness_of :user_id, :scope => :game_id
    before_create :starting_state
    def starting_state
        self.status = "alive"
    end
end
