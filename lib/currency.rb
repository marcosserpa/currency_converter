require "currency/version"
require 'byebug'

module Currency

  @@rates = {}
  @@base = 'BRL'

  class Money

    attr_accessor :amount, :currency

    class << self

      # class methods ===========
      def conversion_rates(currency_base = '', rates = {})
        if currency_base.empty? && rates.empty?
          raise ArgumentError, "Entry's format must be 'BASE_CURRENCY', { 'CONVERSION_RATE_1' => RATE_1,
            'CONVERSION_RATE_2' => RATE_2, etc... }"
        end

        @@base = currency_base

        unless rates.empty?
          @@rates = rates
        end
      end

      def rates
        @@rates
      end

    end

    # instance methods ===========
    def initialize(amount = 0, currency = @@base)
      @amount = amount
      @currency = currency
    end

    def convert_to(currency)
      if !@@rates.empty? && @@rates.include?(currency)
        value = amount * @@rates[currency]
      else
        "Currency rate not defined"
      end
    end

    def inspect
      "#{ amount.to_f } #{ currency }"
    end
  end

end
