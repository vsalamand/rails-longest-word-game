require 'open-uri'
require 'json'

class PagesController < ApplicationController
  def game
    @grid = generate_grid(9)
  end

  def score
    @grid = params[:grid]
    @attempt = params[:shot]
    @start_time = Time.parse(params[:time])
    @end_time = Time.now
    @result = run_game(@attempt, @grid, @start_time, @end_time)
    @time = @result[:time].round(2)
    @score = @result[:score]
    @message = @result[:message]
  end


  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    grid = Array.new(grid_size)
    grid.map! do
      ('A'..'Z').to_a.sample
    end
  end

  def grid_check?(attempt, grid)
    attempt.upcase.chars.all? { |letter| attempt.upcase.count(letter) <= grid.count(letter) }
  end

  def a_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    dictionary = open(url).read
    answer = JSON.parse(dictionary)
    answer["found"]
    p answer["length"]
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result
    result = {}
    result[:time] = end_time - start_time
    result[:translation] = ""
    return { time: result[:time], score: 0.0, message: "the word is not in the grid" } unless grid_check?(attempt, grid)

    if a_word?(attempt)
      result[:score] = attempt.size.to_f / result[:time]
      return { time: result[:time], score: result[:score], message: "well done !" }
    else
      return { time: result[:time], score: 0.0, message: "not an english word" }
    end
  end
end
