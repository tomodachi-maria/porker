module API
  module Ver1
    class ResultsAndBest < Grape::API
      resource :check do

        #POST htpp://localhost3000/api/v1/check
        desc 'check all cards'
        params do
          requires :cards, type:String #cards = ["~~","~~","~~"]にしたいんだから、arrayとかじゃないとダメかなて…存在するのかな?
        end

        post :results do

          puts params[:cards]
          # helpers do
          #   def check_each_card#入力した手札それぞれの役を判定する。
          #     @hands = []
          #     cards.each do |card|
          #       @cards = HandCheck.new(params[:card]) #card(=1つの手札の文字列)のデータを持ったHandCheckに@cardsという名前をつける。
          #       @cards.check_result #これいけるんかな?
          #       @hands.push(@cards.result) #hands = [RESULT_STRAIGHT_FLASH,RESULT_ONE_PAIR,..]のようになる?
          #     end
          #     cards = @cards
          #   end
          #
          #   def check_the_best
          #     hands_index = [RESULT_STRAIGHT_FLASH,RESULT_FOUR_OF_A_KIND,RESULT_FULLHOUSE,RESULT_FLASH,RESULT_STRAIGHT,RESULT_THREE_OF_A_KIND,RESULT_TWO_PAIR,RESULT_ONE_PAIR,RESULT_HIGH_CARD]
          #     #各役の強さを数字に置き換える。
          #     hands_index.each do |r,idx|
          #       @hands[@hands.index(r)] = idx
          #       end
          #     #一番数字が小さいのをtrue,それ以外をfalseにする。
          #     @hands
          #
          #
          #   end
          # end
           #返り値
          #present :hash_id ,hash_id

        end


      end
    end
  end
end

