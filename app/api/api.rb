class API < Grape::API
  insert_after Grape::Middleware::Formatter, Grape::Middleware::Logger

  # rescue_from :all

  mount V1::Endpoint
end
