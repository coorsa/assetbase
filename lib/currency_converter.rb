require 'eu_central_bank'
class Convert

  def currency
    bank = EuCentralBank.new
    Money.default_bank = bank
    money1 = Money.new(100)
    money1.bank # bank

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
    bank.exchange_with(Money.new(100, "EUR"), "USD") # Money.new(80, "USD"
  end
end
