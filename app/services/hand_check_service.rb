module HandCheckModule
  class HandCheck
    require_relative "./fixed_messages"
    include FixedMessages
    require_relative "./regexes"
    include Regexes
    attr_reader :cards, :errors, :hand, :power, :best

    def initialize(cards)
      @cards = cards
      @card_ary = @cards.split
      @straight = false
      @flash = false
      @best = false
    end

    def check_error
      check_same_cards
      check_unsuitable
      check_card_size
    end

    def check_result
      check_straight?
      check_flash?
      count_num_pairs
      case [@straight,@flash, @num_pairs]
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
      # @@max_power = 0
      # @@max_power = @power if @@max_power < @power
    end

    # def check_best
    #   @best = true if @power == @@max_power
    # end

    private

    def check_card_size
      card = @cards.split(/ /, -1)
      @errors = ERROR_CARD_SIZE if card.size != 5 || @card_ary.size != 5
    end

    def check_unsuitable
      errors = []
      @card_ary.each_with_index do |card,idx|
        errors.push("#{idx + 1}#{ERROR_WHERE_IS_WRONG}(#{@card_ary[idx]})") unless card.match?(REGEX_ACCEPTABLE)
      end
      @errors = [].concat(errors).push(ERROR_UNSUITABLE) if errors.present?
    end

    def check_same_cards
        @errors = ERROR_SAME_CARDS unless @card_ary.count == @card_ary.uniq.count
    end

    def check_straight?
      num = @cards.gsub(/S|H|D|C/, "S" => "", "H" => "", "D" => "", "C" => "")
      @num_ary = num.split.map(&:to_i)
      num_sort = @num_ary.sort.reverse
      if num_sort[0] == num_sort[1] + 1 &&
        num_sort[1] + 1 == num_sort[2] + 2 &&
        num_sort[2] + 2 == num_sort[3] + 3 &&
        num_sort[3] + 3 == num_sort[4] + 4
        @straight = true
      elsif num_sort == [13,12,11,10,1]
        @straight = true
      else
        @straight = false
      end
    end

    def check_flash?
      suit = @cards.gsub(/\d/,"")
      suit_ary = suit.split
      @flash = true if suit_ary.uniq.size == 1
    end

    def count_num_pairs
      num_pairs_hash = @num_ary.group_by(&:itself).transform_values(&:size) #{10=>1, 1=>2, 3=>1, 4=>1}みたいになる。
      num_pairs_array = num_pairs_hash.map{ |_, value| value } #[1,2,1,1]みたいになる。同じ数字の枚数を配列にする。
      @num_pairs = num_pairs_array.sort.reverse
    end
  end
end
