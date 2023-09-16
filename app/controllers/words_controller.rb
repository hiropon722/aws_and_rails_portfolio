class WordsController < ApplicationController
  def random_word
    random_word = Word.order("RANDOM()").first
    render json: { word: random_word.word }
  end
end
