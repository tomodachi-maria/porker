  class CardsController < ApplicationController
    require_relative "../services/hand_check_service"
    include HandCheckModule
    attr_reader :cards

      def top
      end

      def judge
        @cards = HandCheck.new(params[:cards])
        @cards.check_error
          if @cards.errors.present?
            render :error
          else @cards.check_result
            render :result
          end
      end
  end
