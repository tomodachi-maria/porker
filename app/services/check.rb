module Check
  class HandCheck
    require_relative "./fixed_messages"
    include FixedMessages #include モジュール
    require_relative "./regexes"
    include Regexes #include モジュール

    attr_reader :error , :message

    def initialize(hand)
      @hand = hand
    end

    def errorcheck
      hand_ary = @hand.split
      #文字列handを、そのまま配列にする。※ ["S1","S2","S3","S4","S5"]
      hand_ary_for_error1 = @hand.split(/ /, -1)
      #文字列handを配列にするが、第二引数の負数により連続スペースの間も値になる。

      if
        hand_ary.size != 5 ||
        hand_ary_for_error1.size != 5
          @error = ERROR1_NOT_ENOUGH

      elsif
        @hand.match?(REGEX_0||REGEX_123||REGEX_456789||REGEX_MARK||/\d{3,}/||/[^SDHC0-9]/)
          @error = [ERROR2_UNSUITABLE]
          hand_ary.each_with_index do |a, idx|
            b = a.index(REGEX_0)
            c = a.index(REGEX_123)
            d = a.index(REGEX_456789)
            e = a.index(REGEX_MARK)
            f = a.index(/\d{3,}/)
            g = a.index(/[^SDHC0-9]/)
            @error.push("#{idx + 1}#{ERROR2_WHERE_IS_WRONG}(#{hand_ary[idx]})") if b||c||d||e||f||g
          end

      elsif
        (hand_ary.count - hand_ary.uniq.count) > 0
          @error = ERROR3_SAME_CARDS

      else
          @error = "any errors"
      end #ifのend
    end #defのend


    def handcheck
      #number関連
        hand_num = @hand.gsub(/S|H|D|C/, "S" => "", "H" => "", "D" => "", "C" => "")
        #文字列からS/H/D/Cを消して数字だけの文字列に。※ "10 1 3 4 1"
        num = hand_num.split.map(&:to_i)
        #num = [10,1,3,4,1] （各要素は数字）みたいになる。ここから配列になっている。
        num_for_straight= num.sort.reverse
        num_pairs_hash = num.group_by(&:itself).transform_values(&:size)
        #{10=>1, 1=>2, 3=>1, 4=>1}みたいになる。
        nums_pairs_array = num_pairs_hash.map{ |_, value| value }
        #[1,2,1,1]みたいになる。同じ数字の枚数を配列にする。
        nums_pairs = nums_pairs_array.sort.reverse
        #[2,1,1,1]みたいになる。同じ数字の枚数を多い順に配列にする。
      #mark関連
        mark_base = @hand.gsub(/\d/,"")
        mark = mark_base.split
        #hand_mark = [H, D, S, D, S] みたいになる。
        mark_pairs_hash = mark.group_by(&:itself).transform_values(&:size)
        #{H=>1, D=>2, S=>2}みたいになる。マークごとの枚数を数える。
        marks_pairs = mark_pairs_hash.map{ |_, value| value }
        #[1, 2, 2]みたいになる。同じマークの枚数を配列にする。
      if
        num_for_straight[0] == num_for_straight[1] + 1 &&
        num_for_straight[1] + 1 == num_for_straight[2] + 2 &&
        num_for_straight[2] + 2 == num_for_straight[3] + 3 &&
        num_for_straight[3] + 3 == num_for_straight[4] + 4 &&
        marks_pairs.max{|a, b| a.to_f <=> b.to_f} == 5
        #最後の条件文は、配列中の最大値が５＝「同じマークが５枚ある」ことを示している。
          @message = RESULT_STRAIGHT_FLASH

      elsif
        num_for_straight == [13,12,11,10,1] &&
        marks_pairs.max{|a, b| a.to_f <=> b.to_f} == 5
          @message = RESULT_STRAIGHT_FLASH

      elsif
        nums_pairs == [4,1]
          @message = RESULT_FOUR_OF_A_KIND

      elsif
        nums_pairs == [3,2]
          @message = RESULT_FULLHOUSE

      elsif
        marks_pairs.max{|a, b| a.to_f <=> b.to_f} == 5
          @message = RESULT_FLASH

      elsif
        num_for_straight[0] == num_for_straight[1] + 1 &&
        num_for_straight[1] + 1 == num_for_straight[2] + 2 &&
        num_for_straight[2] + 2 == num_for_straight[3] + 3 &&
        num_for_straight[3] + 3 == num_for_straight[4] + 4
          @message = RESULT_STRAIGHT

      elsif
        num_for_straight == [13,12,11,10,1]
          @message = RESULT_STRAIGHT

      elsif
        nums_pairs == [3,1,1]
          @message = RESULT_THREE_OF_A_KIND

      elsif
        nums_pairs == [2,2,1]
          @message = RESULT_TWO_PAIR

      elsif
        nums_pairs == [2,1,1,1]
          @message = RESULT_ONE_PAIR

      else
          @message = RESULT_HIGH_CARD
      end #ifのend
    end #defのend

  end #classのend
end #moduleのend
