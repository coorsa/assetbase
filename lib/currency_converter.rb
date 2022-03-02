require 'eu_central_bank'
class Convert

  def currency(quantity, currency_in, currency_out)
    bank = EuCentralBank.new
    Money.default_bank = bank

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

    # exchange 100 currency#A to currency#B as usual
    bank.exchange_with(Money.new(quantity, currency_in), currency_out)
  end
end
