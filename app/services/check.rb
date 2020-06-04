module Check
  class HandCheck
    require_relative "./fixed_messages"
    include FixedMessages #include モジュール
    require_relative "./regexes"
    include Regexes
    attr_reader :error , :hand ,:cards ,:power ,:best

    def initialize(cards) #initializeメソッドは、initializeメソッドに(cards)(=何か引数)を与えるとそれを@cardsというインスタンス変数にしてくれる。
      @cards = cards
    end
    def check_error
      @cards_ary = @cards.split
      check_error_3
      check_error_2
      check_error_1
    end #defのend

    def check_error_1
      @cards_ary_for_error1 = @cards.split(/ /, -1)
      if  @cards_ary.size != 5 ||
          @cards_ary_for_error1.size != 5
        @error = ERROR1_NOT_FIVE_CARDS
      end
    end

    def check_error_2
      error = []
      @cards_ary.each_with_index do |h,idx|
        error.push("#{idx + 1}#{ERROR2_WHERE_IS_WRONG}(#{@cards_ary[idx]})") if h.match?(REGEX_ACCEPTABLE) == false
      end
      @error = [].concat(error).push(ERROR2_UNSUITABLE) if error != []
    end

    def check_error_3
      if @cards_ary.count > @cards_ary.uniq.count
        @error = ERROR3_SAME_CARDS
      end
    end

    #-------------------------------------------------------------------------
    def check_result
      cards_num = @cards.gsub(/S|H|D|C/, "S" => "", "H" => "", "D" => "", "C" => "")
      @num_array = cards_num.split.map(&:to_i) #[10,1,3,4,1]（配列内の各要素は数字）みたいになる。
      num_for_straight= @num_array.sort.reverse
      num_pairs_hash = @num_array.group_by(&:itself).transform_values(&:size) #{10=>1, 1=>2, 3=>1, 4=>1}みたいになる。
      num_pairs_array = num_pairs_hash.map{ |_, value| value } #[1,2,1,1]みたいになる。同じ数字の枚数を配列にする。
      num_pairs = num_pairs_array.sort.reverse

      cards_mark = @cards.gsub(/\d/,"")
      mark_array = cards_mark.split
      mark_pairs_hash = mark_array.group_by(&:itself).transform_values(&:size) #{H=>1, D=>2, S=>2}みたいになる。
      @marks_pairs = mark_pairs_hash.map{ |_, value| value } #[1, 2, 2]みたいになる。同じマークの枚数を配列にする。

      case [check_straight?,check_flash?,num_pairs]
      when [true,true,[1,1,1,1,1]]
        @hand = RESULT_STRAIGHT_FLASH
        @power = 9

      when [false,false,[4,1]]
        @hand = RESULT_FOUR_OF_A_KIND
        @power = 8

      when [false,false,[3,2]]
        @hand = RESULT_FULLHOUSE
        @power = 7

      when [false,true,[1,1,1,1,1]]
        @hand = RESULT_FLASH
        @power = 6

      when [true,false,[1,1,1,1,1]]
        @hand = RESULT_STRAIGHT
        @power = 5

      when [false,false,[3,1,1]]
        @hand = RESULT_THREE_OF_A_KIND
        @power = 4

      when [false,false,[2,2,1]]
        @hand = RESULT_TWO_PAIR
        @power = 3

      when [false,false,[2,1,1,1]]
        @hand = RESULT_ONE_PAIR
        @power = 2
      else
        @hand = RESULT_HIGH_CARD
        @power = 1
      end
    end #defのend


    def check_straight?
      num_for_straight= @num_array.sort.reverse
      if    num_for_straight[0] == num_for_straight[1] + 1 &&
          num_for_straight[1] + 1 == num_for_straight[2] + 2 &&
          num_for_straight[2] + 2 == num_for_straight[3] + 3 &&
          num_for_straight[3] + 3 == num_for_straight[4] + 4
        return true
      elsif num_for_straight == [13,12,11,10,1]
        return true
      else
        return false
      end
    end

    def check_flash?
      return true if @marks_pairs.max{|a, b| a.to_f <=> b.to_f} == 5 #同じマークの枚数の最大値が５、すなわち同じマークが５枚あることを示す。
      false
    end

    def check_the_best(powers, each_power)
      strongest_num = powers.max
      if each_power == strongest_num
        @best = true
      else
        @best = false
      end
    end

  end #classのend
end #moduleのend
