module Check
  class HandCheck
    require_relative "./fixed_messages"
    include FixedMessages #include モジュール
    require_relative "./regexes"
    include Regexes
    attr_reader :error , :result ,:hand

    def initialize(hand) #initializeメソッドは、initializeメソッドに(hand)(=何か引数)を与えるとそれを@handというインスタンス変数にしてくれる。
      @hand = hand
    end
    def check_error
      @hand_ary = @hand.split
      check_error_3
      check_error_2
      check_error_1
    end #defのend

    def check_error_1
      @hand_ary_for_error1 = @hand.split(/ /, -1)
      if  @hand_ary.size != 5 ||
          @hand_ary_for_error1.size != 5
        @error = ERROR1_NOT_FIVE_CARDS
      end
    end

    def check_error_2
      error = []
      @hand_ary.each_with_index do |h,idx|
        error.push("#{idx + 1}#{ERROR2_WHERE_IS_WRONG}(#{@hand_ary[idx]})") if h.match?(REGEX_ACCEPTABLE) == false
      end
      @error = [].concat(error).push(ERROR2_UNSUITABLE) if error != []
    end

    def check_error_3
      if @hand_ary.count > @hand_ary.uniq.count
        @error = ERROR3_SAME_CARDS
      end
    end

    #-------------------------------------------------------------------------
    def check_result
      hand_num = @hand.gsub(/S|H|D|C/, "S" => "", "H" => "", "D" => "", "C" => "")
      @num_array = hand_num.split.map(&:to_i) #[10,1,3,4,1]（配列内の各要素は数字）みたいになる。
      num_for_straight= @num_array.sort.reverse
      num_pairs_hash = @num_array.group_by(&:itself).transform_values(&:size) #{10=>1, 1=>2, 3=>1, 4=>1}みたいになる。
      num_pairs_array = num_pairs_hash.map{ |_, value| value } #[1,2,1,1]みたいになる。同じ数字の枚数を配列にする。
      num_pairs = num_pairs_array.sort.reverse

      hand_mark = @hand.gsub(/\d/,"")
      mark_array = hand_mark.split
      mark_pairs_hash = mark_array.group_by(&:itself).transform_values(&:size) #{H=>1, D=>2, S=>2}みたいになる。
      @marks_pairs = mark_pairs_hash.map{ |_, value| value } #[1, 2, 2]みたいになる。同じマークの枚数を配列にする。

      case [check_straight?,check_flash?,num_pairs]
      when [true,true,[1,1,1,1,1]]
        @result = RESULT_STRAIGHT_FLASH

      when [false,false,[4,1]]
        @result = RESULT_FOUR_OF_A_KIND

      when [false,false,[3,2]]
        @result = RESULT_FULLHOUSE

      when [false,true,[1,1,1,1,1]]
        @result = RESULT_FLASH

      when [true,false,[1,1,1,1,1]]
        @result = RESULT_STRAIGHT

      when [false,false,[3,1,1]]
        @result = RESULT_THREE_OF_A_KIND

      when [false,false,[2,2,1]]
        @result = RESULT_TWO_PAIR

      when [false,false,[2,1,1,1]]
        @result = RESULT_ONE_PAIR
      else
        @result = RESULT_HIGH_CARD
      end
    end #defのend

    private
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


  end #classのend
end #moduleのend
