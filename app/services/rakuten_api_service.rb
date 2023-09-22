class RakutenApiService
  include HTTParty
  base_uri 'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20170706'

  def initialize(api_key)
    @options = { query: { applicationId: api_key } }
  end

  def search_cheapest_price(keyword)
    @options[:query][:keyword] = keyword
    response = self.class.get('', @options)
    cheapest_price = parse_response(response)
    cheapest_price
  end
  
  private

  def parse_response(response)
    # レスポンスをJSON形式からハッシュにパース
    parsed_response = JSON.parse(response.body)
  
    # レスポンスから最安値情報を抽出（例: "Item"ハッシュ内の "minPrice"）
    if parsed_response["Items"] && parsed_response["Items"].any?
      min_price = parsed_response["Items"].min_by { |item| item["Item"]["minPrice"] }
      cheapest_price = min_price["Item"]["minPrice"]
    else
      # レスポンスから最安値情報が見つからなかった場合の処理
      cheapest_price = 1
    end
  
    cheapest_price
  end

end