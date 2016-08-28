class GameViewController < ApplicationController
  def index
    @game = Game.current_game
  end
  def show_game_display
    @game = Game.current_game
    respond_to do |format|
      format.html # game_display.html.erb
      format.js   # game_display.js.erb
    end    
  end
  def scoreboard
    @users = User.order("score desc")
    respond_to do |format|
      format.html # game_display.html.erb
      format.js   # game_display.js.erb
    end        
  end
end
