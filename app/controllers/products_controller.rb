class ProductsController < ApplicationController
  require 'dotenv/load' # .env ファイルをロード
  require 'httparty'

  def upload_excel
    api_key = ENV['RAKUTEN_API_KEY'] # .env ファイルからAPIキーを取得
    uploaded_file = params[:excel_file]
  
    if uploaded_file
      # エクセルファイルをロード
      excel = Roo::Excelx.new(uploaded_file.path)
  
      # シートの選択 (必要に応じてシートを指定)
      excel.default_sheet = excel.sheets.first
  
      # 各行を処理して商品情報を取得
      products = []
      (2..excel.last_row).each do |row|
        product_name = excel.cell(row, 1)
        manufacturer_number = excel.cell(row, 2)
        keyword = excel.cell(row, 3)
        asin = excel.cell(row, 4)
  
        # 商品情報を使って楽天市場で最安値を検索し、productsに追加
        cheapest_price = RakutenApiService.new(api_key).search_cheapest_price(keyword)
  
        products << { product_name: product_name, manufacturer_number: manufacturer_number, keyword: keyword, asin: asin, cheapest_price: cheapest_price }
      end
  
      # @productsに格納
      @products = products
  
      flash[:success] = 'エクセルファイルを処理しました。'
    else
      flash[:error] = 'エクセルファイルを選択してください。'
    end
  
    # リダイレクト先を設定
    redirect_to '/products/show_result'
  end


end
