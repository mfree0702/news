require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "71167510ff86efbd9d45b9d2515f5bf4"

get "/" do
  view "ask"
end

get "/news" do
    @mylocation = params["location"]
    results = Geocoder.search(params["location"])
    lat_lng = results.first.coordinates
    @lat = lat_lng[0]
    @lng = lat_lng[1]
   
    #weather code
    @forecast = ForecastIO.forecast(@lat,@lng).to_hash  
    @current_temp= @forecast["currently"]["temperature"]
    @current_summary = @forecast["currently"]["summary"]
    @daily_forecast = @forecast["daily"]["data"]

    #news code
    url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=a45becd240804b8ba87cfe7aea905dcb"
    @news = HTTParty.get(url).parsed_response.to_hash
    @articles = @news["articles"]
    @top_5_articles = @articles.slice(0,5)
    view "news"
end