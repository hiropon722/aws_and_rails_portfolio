class WordsController < ApplicationController
  def random_word
    random_word = Word.order("RAND()").first
    render json: { word: random_word.word }
  end
end
