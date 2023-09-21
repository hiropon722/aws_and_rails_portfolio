class RakutenApiService
  include HTTParty
  base_uri 'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20170706'

  def initialize(api_key)
    @options = { query: { applicationId: api_key } }
  end

  def search_products(keyword)
    @options[:query][:keyword] = keyword
    response = self.class.get('', @options)
    response.parsed_response['Items']
  end
end