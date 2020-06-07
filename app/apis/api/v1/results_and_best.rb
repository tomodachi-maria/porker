module API
  module V1
    class ResultsAndBest < Grape::API
      require "./app/services/check"
      include Check

      resource :cards do
        desc 'check all cards'
        params do
          requires :cards, type:Array[String]
        end

        post :check do
          card_set = params[:cards]
          each_card = []
          card_set.each do |card|
            handcheck = HandCheck.new(card)
            handcheck.check_error
            handcheck.check_result
            each_card.push(handcheck)
          end

          

          powers = []
          each_card.each do |c|
            powers.push(c.power)
          end

          collect_card_return = []
          error_card_return = []
          each_card.each do |c|
            if  c.power == powers.max
              @best = true
            else
              @best = false
            end
            if c.error == nil
            collect_card_return.push({"card":c.cards, "hand":c.hand, "best":@best})
            else
            error_card_return.push({"card":c.cards, "msg":c.error})
          end
          end

          p = {}
          if collect_card_return != nil && error_card_return != nil
            p.store("result",collect_card_return)
            p.store("error",error_card_return)
          elsif collect_card_return == nil
            p.store("error",error_card_return)
          else  error_card_return == nil
            p.store("result",collect_card_return)
          end

          present p

         end
       end
      end
    end
  end
