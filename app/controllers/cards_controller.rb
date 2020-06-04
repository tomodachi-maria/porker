  class CardsController < ApplicationController
    require_relative "../services/check"
    include Check  #include モジュール
    attr_reader :cards

      def top
      end

      def judge
        @cards = HandCheck.new(params[:cards]) #paramsのデータを持ったHandCheckに@cardsという名前をつける。
        cards.check_error #HandCheck内のcheck_errorメソッドを通る。
          if   @cards.error != nil #check_errorを通った結果、@cards.errorがnilでなければ、次の行の処理を通す。nilであれば、elseの行を読み込む。
            render :error
          else @cards.check_result
            render :result
          end #ifのend
      end #defのend

  end#classのend
