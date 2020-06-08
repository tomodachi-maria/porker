module API
  module V1
    class Cards < Grape::API
      require "./app/services/hand_check_service"
      include HandCheckModule

      resource :cards do
        desc 'check all cards'
        params do
          requires :cards, type:Array[String]
        end
        post :check do
          cards_set = params[:cards]
          handcheck_list = []
          cards_set.each do |card|
            handcheck = HandCheck.new(card)
            handcheck.check_error
            handcheck.check_result if handcheck.errors.nil?
            handcheck_list.push(handcheck)
          end

          results = []
          errors = []
          handcheck_list.each do |handcheck|
            if handcheck.errors.nil?
              handcheck.check_best
              results.push({"card":handcheck.cards, "hand":handcheck.hand, "best":handcheck.best})
            else
              errors.push({"card":handcheck.cards, "msg":handcheck.errors})
            end
          end

          return_json = {}
          return_json.store("result",results) if results.present?
          return_json.store("error",errors) if errors.present?
          present return_json
         end
       end
      end
    end
  end
