  class CardsController < ApplicationController
    require_relative "../services/check"
    include Check  #include モジュール
    attr_reader :cards

      def top
      end

      def judge
        @cards = HandCheck.new(params[:cards]) #HandCheck（クラスメソッド）を生成し、@cardsという名前をつける。その時、引数としてparamsのデータを送っている。
        @cards.check_error #HandCheck内のcheck_errorメソッドを通る。
          if @cards.error != nil
            render :error
          else @cards.check_result
            render :result
          end
      end
  end
