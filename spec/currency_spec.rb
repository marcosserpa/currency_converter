require 'spec_helper'

describe Currency do

  describe '#new' do
    context "when creating an object" do
      money = Currency::Money.new(10, 'EUR')

      it { expect(money.amount).to eq(10) }
      it { expect(money.currency).to eq('EUR') }
    end
  end

  describe '#convert_to' do
    Currency::Money.conversion_rates('BRL', { 'USD' => 3.88 })
    let(:money) { Currency::Money.new(10, 'BRL') }

    context "when currency is defined" do
      it { expect(money.convert_to('USD')).to eq(38.8) }
    end

    context "when currency is not defined" do
      it { expect(money.convert_to('EUR')).to eq("Currency rate not defined") }
    end
  end

  describe '.conversion_rates' do
    context "whe entry has no arguments" do
      it { expect{ Currency::Money.conversion_rates() }.to raise_error(ArgumentError) }
    end

    context "when entry is complete" do
      Currency::Money.conversion_rates('EUR', { 'USD' => 3.88 })

      it { expect(Currency::Money.rates).to match('USD' => 3.88) }
    end
  end

  describe '#inspect' do
    context "when inspected" do
      money = Currency::Money.new(10, 'BRL')

      it { expect(money.inspect).to eq("10.0 BRL") }
    end
  end

  # arithmetic and logic operations override
  describe '#+' do
    Currency::Money.conversion_rates('BRL')
    let(:money) { Currency::Money.new(50, 'BRL') }

    context "when passed a Money object" do
      tip = Currency::Money.new(10, 'BRL')

      it { expect(money + tip).to eq("60 BRL") }
    end

    context "when passed a number" do
      it {  expect(money + 20).to eq("70 BRL") }
    end
  end

  describe '#-' do
    Currency::Money.conversion_rates('BRL')
    let(:money) { Currency::Money.new(50, 'BRL') }

    context "when passed a Money object" do
      tip = Currency::Money.new(10, 'BRL')

      it { expect(money - tip).to eq("40 BRL") }
    end

    context "when passed a number" do
      it {  expect(money - 20).to eq("30 BRL") }
    end
  end

  describe '#*' do
    Currency::Money.conversion_rates('BRL')
    let(:money) { Currency::Money.new(50, 'BRL') }

    context "when passed a Money object" do
      tip = Currency::Money.new(10, 'BRL')

      it { expect(money * tip).to eq("500 BRL") }
    end

    context "when passed a number" do
      it {  expect(money * 20).to eq("1000 BRL") }
    end
  end

  describe '#/' do
    Currency::Money.conversion_rates('BRL')
    let(:money) { Currency::Money.new(50, 'BRL') }

    context "when passed a Money object" do
      tip = Currency::Money.new(10, 'BRL')

      it { expect(money / tip).to eq("5 BRL") }
    end

    context "when passed a number" do
      it {  expect(money / 20).to eq("2.5 BRL") }
    end
  end

  describe '#>' do
    let(:ten) { Currency::Money.new(10, 'BRL') }
    let(:twenty) { Currency::Money.new(20, 'BRL') }

    context "when first is major than second" do
      it { expect(twenty > ten).to eq(true) }
    end

    context "when second is major than first" do
      it { expect(ten > twenty).to eq(false) }
    end
  end

  describe '#<' do
    let(:ten) { Currency::Money.new(10, 'BRL') }
    let(:twenty) { Currency::Money.new(20, 'BRL') }

    context "when first is minor than second" do
      it { expect(ten < twenty).to eq(true) }
    end

    context "when second is minor than first" do
      it { expect(twenty < ten).to eq(false) }
    end
  end

  describe '#==' do
    let(:money_1) { Currency::Money.new(10, 'BRL') }

    context "when both have same amount and currency" do
      money_2 = Currency::Money.new(10, 'BRL')

      it { expect(money_1 == money_2).to eq(true) }
    end

    context "when at least one is different" do
      money_2 = Currency::Money.new(20, 'BRL')

      it { expect(money_1 == money_2).to eq(false) }

      money_3 = Currency::Money.new(10, 'EUR')

      it { expect(money_1 == money_3).to eq(false) }
    end

    context "when amount and currency are different" do
      money_4 = Currency::Money.new(20, 'JPY')

      it { expect(money_1 == money_4).to eq(false) }
    end
  end

end
