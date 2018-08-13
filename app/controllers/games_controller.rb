require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(9)
  end

  def score
    @word = params[:word]
    puts "j'imprime #{params[:letters]}"
    @grid = params[:letters].split(" ")
    p @grid
    @score = run_game(@word, params[:letters])
  end

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    alphabet = [*"A".."Z"]
    voyelles = ["A", "E", "I", "O", "U", "Y"]
    grid = []
     count = 0
    (1..grid_size).each do |letter|
      # pour une iteration sur deux afficher une random voyelle
      if count.even?
        grid << voyelles.sample
      else
        grid << alphabet.sample
      end
      count += 1
    end
    grid.sample(grid_size)
  end

  def run_game(attempt, grid)
    result = {}
    score = 0.0
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    dictionnary_serialized = open(url).read
    dictionnary = JSON.parse(dictionnary_serialized)
    match_attempt = attempt.upcase.scan /\w/
    match_attempt.each do |element|
      if dictionnary['found'] && grid.include?(element) == true
        return "Congratulations! #{attempt} is a valid English word!"
      elsif dictionnary['found'] == false
       return "Sorry but #{attempt} does not seem to be a valid English word..."
      else
        return "Sorry but #{attempt} can't be built out of #{grid}"
      end
    end
  end
end

