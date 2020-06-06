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
          collect_card_set = []
          error_card_set = []
          card_set.each do |card|
            handcheck_each = HandCheck.new(card)
            handcheck_each.check_error #とりまエラー通して、collect_card_set/error_card_setに振り分ける。
            if handcheck_each.error == nil #nil? =>trueなら処理する。
              collect_card_set.push(HandCheck.new(card))
            else
              error_card_set.push(HandCheck.new(card))
            end
          end

          powers = []
          collect_card_set.each do |c|
            c.check_result #@powerを持つ。
            powers.push(c.power)#powers = [1,4,4,6]みたいになる
          end

          # collect_card_set.each do |c|
          #   if  c.power == powers.max
          #     @best = true
          #   else
          #     @best = false
          #   end
          # end

            collect_card_return = []
            collect_card_set.each do |c|
              if  c.power == powers.max
                a = {"card" => c.cards,
                    "hand" => c.hand,
                    "best" => true
                      }
              else
                a = {"card" => c.cards,
                    "hand" => c.hand,
                    "best" => false
                      }
              end
              collect_card_return.push(a)
            end

            pp "collect_card_return"
            pp collect_card_return

          error_card_return = []
          error_card_set.each do |e|
            e.check_error
            a = {"card" => e.cards,
                 "msg" => e.error
                }
            error_card_return.push(a)
          end

          p = {}
          if collect_card_set.empty? == false && error_card_set.empty? == false #エラーも正しいのも両方ある。
            p.store("result",collect_card_return)
            p.store("error",error_card_return)
          elsif collect_card_set.empty? == true
            p.store("error",error_card_return)
          else  error_card_set.empty? == true
            p.store("result",collect_card_return)
          end

          present p

         end
       end
      end
    end
  end
