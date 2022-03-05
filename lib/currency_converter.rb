require 'eu_central_bank'
class Convert
  def self.currency(quantity, currency_in, currency_out)
    # We set our bank
    bank = EuCentralBank.new
    Money.default_bank = bank

    # cached location to save our rates
    cache = "lib/exchange_rates.xml"

    # saves the rates in a specified location
    bank.save_rates(cache)

    # reads the rates from the specified location
    bank.update_rates(cache)

    # Here we update the rates once a day or you can change it if needed
    if !bank.rates_updated_at || bank.rates_updated_at < Time.now - 1.days
      bank.save_rates(cache)
      bank.update_rates(cache)
    end

    # Now we do the exchange from value of currency#A to currency#B
    bank.exchange_with(Money.new(quantity*100, currency_in), currency_out)
  end
end
