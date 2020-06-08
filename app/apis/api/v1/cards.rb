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
          max_power = 0
          cards_set.each do |card|
            handcheck = HandCheck.new(card)
            handcheck.check_error
            if handcheck.errors.nil?
              handcheck.check_result
              max_power = handcheck.power if max_power < handcheck.power
            end
            handcheck_list.push(handcheck)
          end

          results = []
          errors = []
          handcheck_list.each do |handcheck|
            if handcheck.errors.nil?
              # handcheck.check_best
              best =false
              best = true if handcheck.power == max_power
              results.push({"card":handcheck.cards, "hand":handcheck.hand, "best":best})
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
