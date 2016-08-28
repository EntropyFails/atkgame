class GamesController < ApplicationController
before_filter :ensure_gamemaster, :except => [:join, :answerT, :answerF]
#admin actions
  def start
    @game = Game.find(params[:id])
    @game.start
    redirect_to @game
  end

  def end
    @game = Game.find(params[:id])
    @game.end
    redirect_to @game
  end  
  
  def end_round
    @game = Game.find(params[:id])
    @game.end_round
    redirect_to @game
  end

  
  def index
    @games = Game.all
  end
  
  def create
    @game = Game.new
    @game.title = params[:game][:title]
    @game.save
    if @game.valid?
        redirect_to @game
    else
        render :new
    end
  end
  
  def new
    @game = Game.new
  end
  
  def show
    @game = Game.find(params[:id])
    @new_question = Question.new
  end

  
  # Game Actions here for now
  def join
    @game = Game.find(params[:id])
    Player.create(:game_id => @game.id, :user_id => @user.id)
    redirect_to root_url
  end
  
  def answerT
    answer("T")
  end
  
  def answerF
    answer("F")
  end
  
  
  def answer(response)
    @game = Game.find(params[:id])

    if @user.in_current_game && @user.is_alive(@game) && !@user.answered_current_question?(@game)
        Answer.create(:question_id => @game.current_question.id, :user_id => @user.id, :response => response)
    end

    respond_to do |format|
      format.js   { render "games/answer_clear" }
      format.json { render :json => { :result => 'success' }, :layout => false } 
    end

  end
  
  private
    def game_params
        params.require(:game).permit(:title)
    end
    def ensure_gamemaster
        if @user.name == "atk402" || @user.name == "entropyfails" || @user.name == "wakusei"
            return true
        end
        return false
    end
end
