module API
  module Ver1
    class Root < Grape::API
      #http://localhost:3000/api/ver1
      version 'ver1'
      format :json

      mount API::Ver1::ResultsAndBest
    end
  end
end