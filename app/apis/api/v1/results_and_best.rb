module API
  module V1
    class ResultsAndBest < Grape::API
      require "./app/services/check"
      include Check


      resource :cards do
        #POST htpp://localhost3000/api/v1/cards

        desc 'check all cards'
        params do
          requires :cards, type:Array[String]
        end

        post :check do
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
                 "msg" => o.error
                }
            error_cards.push(a)
          end

          c = {}
          if collect_cards.empty? == false && error_cards.empty? == false
            c.store("result",collect_cards)
            c.store("error",error_cards)
          elsif collect_cards.empty? == true
            c.store("error",error_cards)
          else  error_cards.empty? == true
            c.store("result",collect_cards)
          end

          present c

         end
       end
      end
    end
  end
