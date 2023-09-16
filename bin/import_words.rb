require 'csv'

CSV.foreach('words.csv') do |row|
  Word.create(word: row[0])
end