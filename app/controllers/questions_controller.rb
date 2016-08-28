class QuestionsController < ApplicationController
    def create
        @game = Game.find(params[:game_id])
        @game.questions.create(params[:question])
        redirect_to @game
    end
    def update
        @game = Game.find(params[:game_id])
        @question = Question.find(params[:id])
        @question.update_attributes(params[:question])
        redirect_to @game
    end
end
