module Check
 class HandCheck
   attr_reader :error , :message

   def initialize(hand)
     @hand = hand
   end

   def errorcheck
      hand_num = @hand.gsub(/S|H|D|C/, "S" => "", "H" => "", "D" => "", "C" => "")
      #文字列からS/H/D/Cを消して数字だけの文字列に。エラー判定にも利用。
      hand_empty = hand_num.gsub(/\d/,"")
      #文字列から半角数字を消す。
      hand_ary = @hand.split(/ /, -1)
      #文字列handを、そのまま配列にする。
      #第二引数の負数により文頭/末のスペースでも区切られる。連続スペースの間も値になる（S1__S2(半角スペース2連続)→ "S1", "", "S2"）。

    if hand_ary.size != 5
      @error = '5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"）'

    elsif /\d{3,}/=~ hand_num ||
     #3桁以上の数字があったらとりあえずはじく。以下全部１桁または２桁に関しての話。
     /(?<!S|H|D|C|1)(1|2|3)/=~ @hand ||
     /(?<!S|H|D|C)(4|5|6|7|8|9)/=~ @hand ||
     /(?<!1)0/=~ @hand ||
     hand_empty.match?(/\S/)
      @error = "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"

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
      @message = "ストレートフラッシュ！！最強！"

    elsif num_forstraight == [13,12,11,10,1] &&
     marks_pairs.max{|a, b| a.to_f <=> b.to_f} == 5
      @message = "ストレートフラッシュ！！最強！"

    elsif nums_pairs == [4,1]
      @message = "フォー・オブ・ア・カインドだ！強いね！"

    elsif nums_pairs == [3,2]
      @message = "フルハウスだ！かっこいい！"

    elsif marks_pairs.max{|a, b| a.to_f <=> b.to_f} == 5
      @message = "フラッシュですね素晴らしいです！"

    elsif num_forstraight[0] == num_forstraight[1] + 1 &&
     num_forstraight[1] + 1 == num_forstraight[2] + 2 &&
     num_forstraight[2] + 2 == num_forstraight[3] + 3 &&
     num_forstraight[3] + 3 == num_forstraight[4] + 4
      @message = "ストレート！いけてる！"

    elsif num_forstraight == [14,5,4,3,2]
      @message = "ストレート！いけてる！"

    elsif nums_pairs == [3,1,1]
      @message = "スリー・オブ・ア・カインドだね！いいね！"

    elsif nums_pairs == [2,2,1]
      @message = "ツーペアだね！いいね！"

    elsif nums_pairs == [2,1,1,1]
      @message = "ワンペアだね！いいね！"

    else
      @message = "ハイカード"
    end #ifのend
   end #defのend

 end #classのend
end #moduleのend
