require 'rails_helper'

RSpec.describe 'Card info', type: :request do

  describe 'valid card' do
    before { get '/api/v1/card_info?card_number=4012888888881881' }

    it 'returns Card info' do
      expect(json['exist']).to eq(true)
      expect(json['system_name']).to eq('VISA')
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET valid sberbank card' do
    before { get '/api/v1/card_info?card_number=401288888888188100' }

    it 'returns Card info' do
      expect(json['exist']).to eq(true)
      expect(json['system_name']).to eq('VISA')
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'invalid card' do
    shared_examples 'invalid expectation' do
      it 'returns error' do
        expect(json['error']).not_to be_empty
      end

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end
    end

    context 'with 17 card number' do
      before { get '/api/v1/card_info?card_number=12345678901234567' }
      include_examples 'invalid expectation'
    end

    context 'without card number' do
      before { get '/api/v1/card_info' }
      include_examples 'invalid expectation'
    end

    context 'with empty card number' do
      before { get '/api/v1/card_info?card_number=' }
      include_examples 'invalid expectation'
    end

    context 'with short card number' do
      before { get '/api/v1/card_info?card_number=123' }
      include_examples 'invalid expectation'
    end

    context 'with long card number' do
      before { get '/api/v1/card_info?card_number=12345678901234567890' }
      include_examples 'invalid expectation'
    end

  end
end