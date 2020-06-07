module API
  class Root < Grape::API
    include FixedMessages
    prefix 'api'
    format :json

    #エンドポイントの指定が違う時,POSTじゃない時
    route :any, '*path' do
      error!({"error" => [{ "msg" => API_ERROR_404}] } , 404)
    end

    #paramsがcardsじゃない時
    rescue_from Grape::Exceptions::Base do
      error!({"error" => [{ "msg" => API_ERROR_400}] } , 400)
    end

    #それ以外は500（システムの方に問題があるという風に返す。）
    # rescue_from :all do
    #   error!({"error" => "unexpected error"}, 500)
    # end

    mount API::V1::Root

    end
  end
