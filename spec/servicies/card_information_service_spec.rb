require 'rails_helper'

RSpec.describe CardInformationService do

  describe 'call' do
    it 'exist known card_numbers' do
      card_numbers_with_system_name = {
          '5555555555554444' => 'MasterCard',
          '5105105105105100' => 'MasterCard',
          '4111111111111111' => 'VISA',
          '4012888888881881' => 'VISA',
      }
      card_numbers_with_system_name.each do |card_number, system_name|
        expect(CardInformationService.new(card_number: card_number).call).to eq({
                                                                                    exist: true,
                                                                                    system_name: system_name
                                                                                })
      end
    end

    it 'exist unknown card_numbers' do
      card_numbers = %w(378282246310005 30569309025904 3530111333300000)
      card_numbers.each do |card_number|
        expect(CardInformationService.new(card_number: card_number).call).to eq({
                                                                                    exist: true,
                                                                                    system_name: 'Unknown'
                                                                                })
      end
    end

    it 'unexist card_numbers' do
      card_numbers = %w(378282246310006 30569309025905 3530111333300001)
      card_numbers.each do |card_number|
        expect(CardInformationService.new(card_number: card_number).call).to eq({
                                                                                    exist: false,
                                                                                    system_name: nil
                                                                                })
      end
    end
  end

  # Приватные методы можно не тестировать,
  # но тут у меня было мало данных для edge cases
  # и я проверял на первых 4 цифрах
  describe 'system_name' do
    it 'VISA' do
      card_numbers = %w(4000 4123 4555)
      card_numbers.each do |card_number|
        expect(CardInformationService.new(card_number: card_number).send(:system_name)).to eq('VISA')
      end
    end

    it 'Maestro' do
      card_numbers = %w(6123 5021 5621 5721 5822)
      card_numbers.each do |card_number|
        expect(CardInformationService.new(card_number: card_number).send(:system_name)).to eq('Maestro')
      end
    end

    it 'MasterCard' do
      card_numbers = %w(5154 5545 5312 2221 2542 2720)
      card_numbers.each do |card_number|
        expect(CardInformationService.new(card_number: card_number).send(:system_name)).to eq('MasterCard')
      end
    end

    it 'Unknown' do
      card_numbers = %w(3000 1000 5916 2220 2721)
      card_numbers.each do |card_number|
        expect(CardInformationService.new(card_number: card_number).send(:system_name)).to eq('Unknown')
      end
    end
  end
end