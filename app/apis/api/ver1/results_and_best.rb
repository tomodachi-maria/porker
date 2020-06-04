module API
  module Ver1
    class ResultsAndBest < Grape::API
      require "./app/services/check"
      include Check



      resource :check do
        #POST htpp://localhost3000/api/ver1/check
        desc 'check all cards'
        params do
          requires :cards, type:Array[String]
        end

        post :results do
          @card_set = params[:cards]
          each_object = []
          @card_set.each do |card|
            each_object.push(HandCheck.new(card))
          end

          powers = []
          each_object.each do |o|
            o.check_result
            powers.push(o.power)
            o.check_the_best(powers,o.power)
            pp "===3=="
            pp o.power
          end

          pp "===1=="
          pp each_object

          b = []
          each_object.each do |o|
            a = {"card" => o.hand ,
                 "hand" => o.result ,
                 "best" => o.best
                }
            b.push(a)
          end

          c = {"result" => b }

          present c

        end

      end
    end
  end
end