module V1
  class Cards < Grape::API
    desc 'Получить информацию о карте по ее номеру'
    params do
      requires :card_number, type: String, regexp: /^\d{16}$|^\d{18}$/, desc: 'строка с номером карты (стандартный номерной пул - 16 или 18 цифр(в случае сбера)'
    end
    get 'card_info' do
      response = CardInformationService.new(card_number: params[:card_number]).call

      # Тут можно было просто передать response но я предпочитаю явно передавать переменные
      {
          exist: response[:exist],
          system_name: response[:system_name]
      }
    end
  end
end

