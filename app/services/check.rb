module Check
  class HandCheck
    require_relative "./fixed_messages"
    include FixedMessages
    require_relative "./regexes"
    include Regexes

    attr_reader :cards, :error, :hand, :power

    def initialize(cards) #initializeメソッドは、initializeメソッドに何か引数を与えると、それを@cardsというインスタンス変数にしてくれる。
      @cards = cards
    end

    def check_error
      @cards_ary = @cards.split
      check_error_3_same_cards
      check_error_2_unsuitable
      check_error_1_not_five_cards
    end

    def check_result
      case [check_straight?,check_flash?, count_num_pairs]
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
    end


    private

    def check_error_1_not_five_cards
      cards_ary_for_error1 = @cards.split(/ /, -1)
      if @cards_ary.size != 5 ||
        cards_ary_for_error1.size != 5
        @error = ERROR1_NOT_FIVE_CARDS
      end
    end

    def check_error_2_unsuitable
      error = []
      @cards_ary.each_with_index do |h,idx|
        error.push("#{idx + 1}#{ERROR2_WHERE_IS_WRONG}(#{@cards_ary[idx]})") if h.match?(REGEX_ACCEPTABLE) == false
      end
      @error = [].concat(error).push(ERROR2_UNSUITABLE) if error != []
    end

    def check_error_3_same_cards
      if @cards_ary.count > @cards_ary.uniq.count
        @error = ERROR3_SAME_CARDS
      end
    end

    def check_straight?
      @num_string = @cards.gsub(/S|H|D|C/, "S" => "", "H" => "", "D" => "", "C" => "")
      @num_ary = @num_string.split.map(&:to_i)
      num_for_straight = @num_ary.sort.reverse
      if num_for_straight[0] == num_for_straight[1] + 1 &&
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
      mark_string = @cards.gsub(/\d/,"")
      mark_ary = mark_string.split
      if mark_ary.uniq.size == 1
        return true
      else
        return false
      end
    end

    def count_num_pairs
      num_pairs_hash = @num_ary.group_by(&:itself).transform_values(&:size) #{10=>1, 1=>2, 3=>1, 4=>1}みたいになる。
      num_pairs_array = num_pairs_hash.map{ |_, value| value } #[1,2,1,1]みたいになる。同じ数字の枚数を配列にする。
      @num_pairs = num_pairs_array.sort.reverse
    end

  end
end
