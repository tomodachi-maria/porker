module CheckResultAndBest
  class CheckBest
    require_relative "../services/check"
    include Check

    #このメソッドでは、apiで受け取ったcards（配列）を利用して、複数のカードの役を判定します。
    def initialize(cards)
      @some_cards = cards
    end

    def check_each_card #ここでの完成物…@each_result
      @each_result = []
      @each_power = []
      @some_cards.each do |card|
        @card = HandCheck.new(card)
        @card.check_result
        @each_result.push(@card.result) #each_result = [RESULT_STRAIGHT_FLASH,RESULT_ONE_PAIR,..]のようになる?
        @each_power.push(@card.power)#[1,4,2,9]みたいになると嬉しい。
      end
    end

     def check_the_best
       #一番数字が大きいインデックス番号を探す。
        @strongest_card_index = @each_power.index(@each_power.max) #strongest~ = [0,1]などのようになる。
        pp "--3--"
        pp @strongest_card_index
        pp "-----"
        @strongest_card_index.each do |s|
          @each_power[s] = true
        end
        @each_power.each do |p|
          p = false if p != true #こんなんあるのかわからんけど…。値がtrueじゃなかったらfalseに置換したい
        end
     end

    end
  end