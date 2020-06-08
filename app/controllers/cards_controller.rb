  class CardsController < ApplicationController
    require_relative "../services/check"
    include Check  #include モジュール
    attr_reader :cards

      def top
      end

      def judge
        @cards = HandCheck.new(params[:cards])
        @cards.check_error
          if @cards.error.present?
            render :error
          else @cards.check_result
            render :result
          end
      end
  end
