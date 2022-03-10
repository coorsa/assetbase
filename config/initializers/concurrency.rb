 Concurrency.configure do |config|
        config.from_currency = "USD"    #Default value
        config.to_currency = "EUR"  #Default value
        config.api_key = ENV['CONCURRENCY_APIKEY']   #Mandatory value
  end
