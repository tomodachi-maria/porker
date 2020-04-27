module Check
  class HandCheck
    require_relative "./fixed_messages"
    include FixedMessages #include モジュール
    require_relative "./regexes"
    include Regexes #include モジュール
    attr_reader :error , :result ,:hand
      def initialize(hand) #initializeメソッドは、initializeメソッドに(hand)(=何か引数)を与えるとそれを@handというインスタンス変数にしてくれる。
        @hand = hand
      end
      def check_error
        @hand_ary = @hand.split    #文字列handを、そのまま配列にする。※ ["S1","S2","S3","S4","S5"]
        @hand_ary_for_error1 = @hand.split(/ /, -1)    #第二引数の負数により連続スペースの間も値になる。
        @error = nil
        check_error_3
        check_error_2
        check_error_1
      end #defのend
      #-------------------------------------------------------------------------
      def check_error_1
        if  @hand_ary.size != 5 ||
            @hand_ary_for_error1.size != 5
          @error = ERROR1_NOT_FIVE_CARDS
        end
      end
      def check_error_2
        if  @hand.match?(REGEX_0) ||
            @hand.match?(REGEX_123) ||
            @hand.match?(REGEX_456789) ||
            @hand.match?(REGEX_MARK) ||
            @hand.match?(/\d{3,}/) ||
            @hand.match?(/[^SDHC 0-9]/)
          @error = [ERROR2_UNSUITABLE]
          @hand_ary.each_with_index.reverse_each do |a, idx|
            b = a.index(REGEX_0)
            c = a.index(REGEX_123)
            d = a.index(REGEX_456789)
            e = a.index(REGEX_MARK)
            f = a.index(/\d{3,}/)
            g = a.index(/[^SDHC0-9]/)
          @error.unshift("#{idx + 1}#{ERROR2_WHERE_IS_WRONG}(#{@hand_ary[idx]})") if b||c||d||e||f||g
          end
        end
       end
       def check_error_3
         if @hand_ary.count > @hand_ary.uniq.count
          @error = ERROR3_SAME_CARDS
         end
       end
      #-------------------------------------------------------------------------

      def check_result
        #----number関連----
        hand_num = @hand.gsub(/S|H|D|C/, "S" => "", "H" => "", "D" => "", "C" => "")
        num = hand_num.split.map(&:to_i) #[10,1,3,4,1] （配列内の各要素は数字）みたいになる。
        num_for_straight= num.sort.reverse
        num_pairs_hash = num.group_by(&:itself).transform_values(&:size) #{10=>1, 1=>2, 3=>1, 4=>1}みたいになる。
        nums_pairs_array = num_pairs_hash.map{ |_, value| value } #[1,2,1,1]みたいになる。同じ数字の枚数を配列にする。
        nums_pairs = nums_pairs_array.sort.reverse
        #----mark関連----
        mark_base = @hand.gsub(/\d/,"")
        mark = mark_base.split
        mark_pairs_hash = mark.group_by(&:itself).transform_values(&:size) #{H=>1, D=>2, S=>2}みたいになる。
        marks_pairs = mark_pairs_hash.map{ |_, value| value } #[1, 2, 2]みたいになる。同じマークの枚数を配列にする。
        #----役判定----
        if    num_for_straight[0] == num_for_straight[1] + 1 &&
              num_for_straight[1] + 1 == num_for_straight[2] + 2 &&
              num_for_straight[2] + 2 == num_for_straight[3] + 3 &&
              num_for_straight[3] + 3 == num_for_straight[4] + 4 &&
              marks_pairs.max{|a, b| a.to_f <=> b.to_f} == 5 #同じマークの枚数の最大値が５、すなわち「同じマークが５枚ある」ことを示す。
          @result = RESULT_STRAIGHT_FLASH
        elsif num_for_straight == [13,12,11,10,1] &&
              marks_pairs.max{|a, b| a.to_f <=> b.to_f} == 5
          @result = RESULT_STRAIGHT_FLASH
        elsif nums_pairs == [4,1]
          @result = RESULT_FOUR_OF_A_KIND
        elsif nums_pairs == [3,2]
          @result = RESULT_FULLHOUSE
        elsif marks_pairs.max{|a, b| a.to_f <=> b.to_f} == 5
          @result = RESULT_FLASH
        elsif num_for_straight[0] == num_for_straight[1] + 1 &&
              num_for_straight[1] + 1 == num_for_straight[2] + 2 &&
              num_for_straight[2] + 2 == num_for_straight[3] + 3 &&
              num_for_straight[3] + 3 == num_for_straight[4] + 4
          @result = RESULT_STRAIGHT
        elsif num_for_straight == [13,12,11,10,1]
          @result = RESULT_STRAIGHT
        elsif nums_pairs == [3,1,1]
          @result = RESULT_THREE_OF_A_KIND
        elsif nums_pairs == [2,2,1]
          @result = RESULT_TWO_PAIR
        elsif nums_pairs == [2,1,1,1]
          @result = RESULT_ONE_PAIR
        else
          @result = RESULT_HIGH_CARD
        end #ifのend
      end #defのend
  end #classのend
end #moduleのend
