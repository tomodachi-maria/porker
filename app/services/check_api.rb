module CheckApi
  class CheckForApi
    require_relative "./check"
    include Check #課題①のCheckモジュールをinclude

    def check_each_card(cards)
      @cards = cards # =["S1,S2,S3,S4,S5","~~","~~"]
      @results = []
      @cards.each do |card|
        @hand = card
        @hand.check_result #これにより、@result（役名）が決まる。
        @results.push(@result) #これにより、results = []の配列に、@resultが次々に入っていく?
      end


      end

    end


  end