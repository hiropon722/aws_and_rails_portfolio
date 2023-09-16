namespace :import do
  desc 'Import words from CSV'
  task :words => :environment do
    require 'csv'
    
    csv_file = Rails.root.join('db', 'words.csv') # CSVファイルのパスを指定

    CSV.foreach(csv_file, headers: true) do |row|
      Word.create(word: row['word'])
    end
  end
end