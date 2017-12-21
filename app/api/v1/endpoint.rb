module V1
  class Endpoint < Grape::API
    format :json
    version 'v1', using: :path

    mount Cards
  end
end
