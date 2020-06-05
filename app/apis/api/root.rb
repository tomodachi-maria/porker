module API
  class Root < Grape::API
    #http://localhost:3000/api
    prefix 'api'
    format :json

    #エンドポイントの指定が違う時,POSTじゃない時
    route :any, '*path' do
      error!({"error" => [{ "msg" => "不正なURLでござる。"}] } , 404)
    end

    #paramsがcardsじゃない時
    rescue_from Grape::Exceptions::Base do
      error!({"error" => [{ "msg" => "不正なリクエストです。"}] } , 400)
    end

    #それ以外は500（システムの方に問題があるという風に返す。）
    # rescue_from :all do |e|
    #   error!({"error" => "unexpected error"}, 500)
    # end

    mount API::Ver1::Root

    end
  end