require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @string_of_characters = ""
    6.times {
      @string_of_characters << [*"A".."Z"].sample
    }
  end

  def score
    @current_score = session[:current_user_score] || 0
    valid_answer = true
    @prompt = params[:token]
    @answer = params[:answer]
    score_to_add = @answer.length
    @game_result = "Congratulations! #{@answer} is a valid English word!"

    prompt_to_array = @prompt.split("")
    answer_to_array = @answer.upcase.split("")
    answer_to_array.each { |char|
      if !prompt_to_array.include?(char)
        valid_answer = false
        score_to_add = 0
        @game_result = "Sorry but #{@answer} can't be build out of #{@prompt}."
      end
    }

    if valid_answer
      url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
      user_serialized = open(url).read
      user = JSON.parse(user_serialized)
      if !user["found"]
        score_to_add = 0
        @game_result = "Sorry but #{@answer} does not seemt o be a valid English word."
      end
    end

    session[:current_user_score] = @current_score + score_to_add
  end
end
