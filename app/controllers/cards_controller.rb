  class CardsController < ApplicationController
    require_relative "../services/check"
    include Check  #include モジュール

      def top
      end

      def judge
        @cards = HandCheck.new(params[:hand]) #paramsのデータを持ったHandCheckに@cardsという名前をつける。
        @cards.check_error
          if   @cards.error != nil
            render :error
          else @cards.check_result
            render :result
          end #ifのend
      end #defのend

  end#classのend
