module API
  module Ver1
    class ResultAndBest < Grape::API
      resource :check do

        #POST /api/v1/check
        desc 'check all cards'
        params do
          requires :cards, type: Array #cards = ["~~","~~","~~"]にしたいんだから、arrayとかじゃないとダメかなて…存在するのかな?
        end

        post :results do
          # helpers do
          #   def check_each_card#入力した手札それぞれの役を判定する。
          #     hands = []
          #     cards.each do |card|
          #       @cards = HandCheck.new(params[:card]) #card(=1つの手札の文字列)のデータを持ったHandCheckに@cardsという名前をつける。
          #       @cards.check_result #これいけるんかな?
          #       hands.push(@cards.result) #hands = [RESULT_STRAIGHT_FLASH,RESULT_ONE_PAIR,..]のようになる?
          #     end
          #
          #     hands_index = [RESULT_STRAIGHT_FLASH,RESULT_FOUR_OF_A_KIND,RESULT_FULLHOUSE,RESULT_FLASH,RESULT_STRAIGHT,RESULT_THREE_OF_A_KIND,RESULT_TWO_PAIR,RESULT_ONE_PAIR,RESULT_HIGH_CARD]
          #
          #   #各役の強さを数字に置き換える。
          #     hands_index.each do |r,idx|
          #       hands[hands.index(r)] = idx
          #     end
          #
          #   #一番数字が小さいのをtrue,それ以外をfalseにする。
          #
          # end
          #
          #
          #     #返り値
          #     #present :hash_id ,hash_id
          cards
        end


      end
    end
  end
end


# 今日やること
#   到達目標：エラーの設計に入っている。何を調べたら良いかわかっている。
#   小目標
#     APIとpostmanを繋げて、うまく動くのかを随時確かめながら開発できるようにする。
#     データを受け取る時、type :Arrayとかあるのかはっきりさせる。type :Stringならどんなデータになるのかも。
#     数字に置き換えた役を、さらに一番強いのをtrue/それ以外をfalseに置き換えるロジックを作る。
#     別クラスのインスタンスメソッドをAPIファイルの中で用いれるようにする。
#     別クラスのインスタンス変数をAPIファイルの中で用いれるようにする。
#     データを返す部分をどのように書けば良いのかわかる。
#   エラーについてはあまり見えてない
#     エラーを返さなきゃいけない状況ってどんな時か。
#     エラーがあるcardの返り値がお手本のようになるようにする。（粗）
#     エンドポイントが間違っていた時、どこまで対応するのか決める
