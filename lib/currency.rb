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

    def +(value)
      result = if value.is_a? Money
        if value.currency == @@base
          amount + value.amount
        else
          if (defined?(@@rates) == nil) || @@rates.empty? || !@@rates.include?(value.currency)
            "Currency is not defined:"
          else
            amount + value.convert_to(value.currency)
          end
        end
      else
        amount + value
      end

      "#{ result } #{ currency }"
    end

    def -(value)
      result = if value.is_a? Money
        if value.currency == @@base
          amount - value.amount
        else
          if (defined?(@@rates) == nil) || @@rates.empty? || !@@rates.include?(value.currency)
            "Currency is not defined:"
          else
            amount - value.convert_to(value.currency)
          end
        end
      else
        amount - value
      end

      "#{ result } #{ currency }"
    end

    def *(value)
      result = if value.is_a? Money
        if value.currency == @@base
          amount * value.amount
        else
          if (defined?(@@rates) == nil) || @@rates.empty? || !@@rates.include?(value.currency)
            "Currency is not defined:"
          else
            amount * value.convert_to(value.currency)
          end
        end
      else
        amount * value
      end

      "#{ result } #{ currency }"
    end

    def /(value)
      result = if value.is_a? Money
        if value.currency == @@base
          if (amount % value.amount).zero?
            amount / value.amount
          else
            amount.to_f / value.amount
          end
        else
          if (defined?(@@rates) == nil) || @@rates.empty? || !@@rates.include?(value.currency)
            "Currency is not defined:"
          else
            if (amount % value.convert_to(value.currency)).zero?
              amount / value.convert_to(value.currency)
            else
              amount.to_f / value.convert_to(value.currency)
            end
          end
        end
      else
        if (amount % value).zero?
          amount / value
        else
          amount.to_f / value
        end
      end

      "#{ result } #{ currency }"
    end

  end

end
