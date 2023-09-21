class ProductsController < ApplicationController
  require 'dotenv/load' # .env ファイルをロード
  require 'httparty'

  def fetch_and_save
    @keyword = params[:keyword] || 'デフォルトのキーワード' # パラメータから検索キーワードを取得
    api_key = ENV['RAKUTEN_API_KEY'] # .env ファイルからAPIキーを取得

    rakuten_service = RakutenApiService.new(api_key)
    @items = rakuten_service.search_products(@keyword)

    # 商品情報を取得しデータベースに保存した後の処理を追加
    # 例: リダイレクトやレスポンスの表示
  end
end
