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
    valid_answer = true
    @prompt = params[:token]
    @answer = params[:answer]
    @game_result = "Congratulations! #{@answer} is a valid English word!"

    prompt_to_array = @prompt.split("")
    answer_to_array = @answer.upcase.split("")
    answer_to_array.each { |char|
      if !prompt_to_array.include?(char)
        valid_answer = false
        @game_result = "Sorry but #{@answer} can't be build out of #{@prompt}."
      end
    }

    if valid_answer
      url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
      user_serialized = open(url).read
      user = JSON.parse(user_serialized)
      if !user["found"]
        @game_result = "Sorry but #{@answer} does not seemt o be a valid English word."
      end
    end
  end
end
