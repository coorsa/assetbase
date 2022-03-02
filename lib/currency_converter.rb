require 'eu_central_bank'
class Convert

  def currency
    bank = EuCentralBank.new
    Money.default_bank = bank
    money1 = Money.new(10)
    money1.bank # bank

    # call this before calculating exchange rates
    # this will download the rates from ECB
    bank.update_rates

    # exchange 100 CAD to USD
    # API is the same as the money gem
    bank.exchange(100, "CAD", "USD") # Money.new(80, "USD")
    Money.us_dollar(100).exchange_to("CAD")  # Money.new(124, "CAD")

    # using the new exchange_with method
    bank.exchange_with(Money.new(100, "CAD"), "USD")


    # For performance reasons, you may prefer to read from a file instead.
    # Furthermore, ECB publishes their rates daily.
    # It makes sense to save the rates in a file to read from.
    # It also adds an updated_at field so that you can manage the update.

    # cached location
    cache = "./exchange_rates.xml"

    # saves the rates in a specified location
    bank.save_rates(cache)

    # reads the rates from the specified location
    bank.update_rates(cache)

    if !bank.rates_updated_at || bank.rates_updated_at < Time.now - 1.days
      bank.save_rates(cache)
      bank.update_rates(cache)
    end

    # exchange 100 CAD to USD as usual
    bank.exchange_with(Money.new(200, "CAD"), "USD") # Money.new(80, "USD"
  end
end
