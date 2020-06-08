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
          max_power = 0
          handcheck_list = []
          card_set.each do |card|
            handcheck = HandCheck.new(card)
            handcheck.check_error #この段階でやっておけば、あとでまたeach doしてインスタンス変数を生成する必要がなくなる
            if handcheck.error.nil?
              handcheck.check_result
              max_power = handcheck.power if handcheck.power > max_power
            end
            handcheck_list.push(handcheck)
          end

          result = []
          error = []
          handcheck_list.each do |c|
            best = false
            best = true if  c.power == max_power
            if c.error.nil?
              result.push({"card":c.cards, "hand":c.hand, "best":best})
            else
              error.push({"card":c.cards, "msg":c.error})
            end
          end

          p = {}
          p.store("result",result) if result.present?
          p.store("error",error) if error.present?
          present p
         end
       end
      end
    end
    end