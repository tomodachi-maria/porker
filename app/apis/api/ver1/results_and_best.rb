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
          card_set = params[:cards]
          each_object = []
          card_set.each do |card|
            each_object.push(HandCheck.new(card))
          end

          collect_objects = []
          error_objects = []
          each_object.each do |o|
            o.check_error
            if o.error != nil
              error_objects.push(o)
            else
              o.check_result
              collect_objects.push(o)
            end
          end

          @powers = []
          collect_objects.each do |o|
            @powers.push(o.power)
          end

          collect_objects.each do |o|
            o.check_the_best(@powers,o.power)
          end


          collect_cards = []
          collect_objects.each do |o|
            a = {"card" => o.cards,
                 "hand" => o.hand,
                 "best" => o.best
                }
            collect_cards.push(a)
          end

          error_cards = []
          error_objects.each do |o|
            a = {"card" => o.cards,
                 "msg" => o.error.join("\n")
                }
            error_cards.push(a)
          end

          c = {"result" => collect_cards, "error" => error_cards }

          present c

         end
       end
      end
    end
  end

# http://localhost:3000/api/ver1/check/results
