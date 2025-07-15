require 'uri'
require 'net/http'

class StockPriceApi
  def self.get_stock_price(symbol)
    url = URI("https://alpha-vantage.p.rapidapi.com/query?function=TIME_SERIES_DAILY&symbol=#{symbol}&outputsize=compact&datatype=json")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = '7b751feb97msh677e0468da881d4p158468jsnd7d8217352de'
    request["x-rapidapi-host"] = 'alpha-vantage.p.rapidapi.com'

    response = http.request(request)
    JSON.parse(response.body)
  end
end
