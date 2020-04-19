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
      hand_num = @hand.gsub(/S|H|D|C/, "S" => "", "H" => "", "D" => "", "C" => "")
      #文字列からS/H/D/Cを消して数字だけの文字列に。※ "1 2 3 4 5"
      hand_empty = hand_num.gsub(/\d/,"")
      #hand_numからさらに半角数字を消す。※ "    "

      if hand_ary.size != 5 ||
        @hand.start_with?(" ") ||
        @hand.end_with?(" ")
        @error = ERROR1_NOT_ENOUGH

      elsif /\d{3,}/ =~ hand_num ||
        #3桁以上の数字があったらとりあえずはじく。以下全部１桁または２桁に関しての話。
        REGEX_0 =~ @hand ||
        REGEX_123 =~ @hand ||
        REGEX_456789 =~ @hand ||
        REGEX_MARK =~ @hand ||
        hand_empty.match?(/\S/)
        #hand_emptyに半角スペース以外があることを表す。
      #--以下、何枚目のカード指定にエラーがあるかを返すためのパート-------------------------------
        hand_empty_ary = []
        hand_ary.each do|s|
          emp = s.gsub(/S|H|D|C|\d/, "S" => "","H" => "","D" => "","C" => "",/\d/ => "")
          hand_empty_ary.push (emp)
        end #これでhand_empty_aryは、元の文字列@handから、SHDCと半角数字が消えた配列になる。

        where_is_unsuitable_ary0 = []
        hand_ary.each_with_index do |ary, idx|
          t = ary.index(REGEX_0)
          u = ary.index(REGEX_123)
          v = ary.index(REGEX_456789)
          w = ary.index(REGEX_MARK)
          where_is_unsuitable_ary0.push(idx + 1) if t || u || v || w
        end
        hand_empty_ary.each_with_index do |ary, idx|
          x = ary.index(/\S/)
          where_is_unsuitable_ary0.push(idx + 1) if x
        end #これでwhere_is_unsuitable_ary0では、不適切なカードは何枚目にあるかが順不同の配列になった。

        where_is_unsuitable_ary1 = where_is_unsuitable_ary0.map(&:to_i)
        where_is_unsuitable_ary = where_is_unsuitable_ary1.sort
        # where_is_unsuitable_aryでは、何番目のカードが不適切かが「昇順で」書かれていることになる(順番にエラー文を返すため)

        #いよいよ@errorに、エラー文を入れていく。
        @error = ["半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"]
        where_is_unsuitable_ary.each do |y|
          "#{y}番目のカード指定文字が不正です。（#{hand_ary[y - 1]}）"
          @error.push("#{y}番目のカード指定文字が不正です。（#{hand_ary[y - 1]}）")
        end
      #-------------------------------------------------------------------------------------

      elsif (hand_ary.count - hand_ary.uniq.count) > 0
        @error = "カードが重複しています。"

      else
        @error = "any errors"
      end #ifのend
    end #defのend


    def handcheck
      #number関連
        hand_num = @hand.gsub(/S|H|D|C/, "S" => "", "H" => "", "D" => "", "C" => "")
        #文字列からS/H/D/Cを消して数字だけの文字列に。エラー判定にも利用。
        # "10 1 3 4 1"になる。
        num = hand_num.split.map(&:to_i)
        #num = [10,1,3,4,1] （各要素は数字）みたいになる。ここから配列になっている。
        num_forstraight= num.sort.reverse
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
      if num_forstraight[0] == num_forstraight[1] + 1 &&
        num_forstraight[1] + 1 == num_forstraight[2] + 2 &&
        num_forstraight[2] + 2 == num_forstraight[3] + 3 &&
        num_forstraight[3] + 3 == num_forstraight[4] + 4 &&
        marks_pairs.max{|a, b| a.to_f <=> b.to_f} == 5
        #最後の条件文は、配列中の最大値が５＝「同じマークが５枚ある」ことを示している。
          @message = RESULT_STRAIGHT_FLASH

      elsif num_forstraight == [13,12,11,10,1] &&
        marks_pairs.max{|a, b| a.to_f <=> b.to_f} == 5
          @message = RESULT_STRAIGHT_FLASH

      elsif nums_pairs == [4,1]
          @message = RESULT_FOUR_OF_A_KIND

      elsif nums_pairs == [3,2]
          @message = RESULT_FULLHOUSE

      elsif marks_pairs.max{|a, b| a.to_f <=> b.to_f} == 5
          @message = RESULT_FLASH

      elsif num_forstraight[0] == num_forstraight[1] + 1 &&
        num_forstraight[1] + 1 == num_forstraight[2] + 2 &&
        num_forstraight[2] + 2 == num_forstraight[3] + 3 &&
        num_forstraight[3] + 3 == num_forstraight[4] + 4
          @message = RESULT_STRAIGHT

      elsif num_forstraight == [14,5,4,3,2]
          @message = RESULT_STRAIGHT

      elsif nums_pairs == [3,1,1]
          @message = RESULT_THREE_OF_A_KIND

      elsif nums_pairs == [2,2,1]
          @message = RESULT_TWO_PAIR

      elsif nums_pairs == [2,1,1,1]
          @message = RESULT_ONE_PAIR

      else
          @message = RESULT_HIGH_CARD
      end #ifのend
    end #defのend

  end #classのend
end #moduleのend
