require 'uri'
require 'net/http'

class StockPriceApi
  def self.get_stock_price(symbol)
    url = URI("https://alpha-vantage.p.rapidapi.com/query?function=TIME_SERIES_DAILY&symbol=#{symbol}&outputsize=compact&datatype=json")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = ENV['RAPIDAPI_KEY']
    request["x-rapidapi-host"] = ENV['RAPIDAPI_HOST']

    response = http.request(request)
    JSON.parse(response.body)
  end
end
