module API
  module Ver1
    class Events < Grape::API
      resource :check do

        #POST /api/v1/check
        desc 'check all cards'
        params do
          requires :cards, type: String
        end

        post :results do
          .create(
              title: params[:cards],

              #返り値
              #present :hash_id ,hash_id
        end


      end
    end
  end
end