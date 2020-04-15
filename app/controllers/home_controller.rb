class HomeController < ApplicationController
  def top
  end


  def judge
      @hand = params[:hand]
      #この辺まだ文字列
        @hand_num = @hand.gsub(/S|H|D|C/, "S" => "", "H" => "", "D" => "", "C" => "")
        #文字列からS/H/D/Cを消して数字だけの文字列に。エラー判定にも利用。
        # "10 1 3 4 1"になる。
      puts @hand_num

        @num = @hand_num.split.map(&:to_i)
        #@num = [10,1,3,4,1] （各要素は数字）みたいになる。
      #@numから配列！
        @num_forstraight  = @num.sort.reverse
        @num_pairs_hash = @num.group_by(&:itself).transform_values(&:size)
        #{10=>1, 1=>2, 3=>1, 4=>1}みたいになる。
        @nums_pairs_array = @num_pairs_hash.map{ |_, value| value }
        #[1,2,1,1]みたいになる。同じ数字の枚数を配列にする。
        @nums_pairs = @nums_pairs_array.sort.reverse
        #[2,1,1,1]みたいになる。同じ数字の枚数を多い順に配列にする。

      #この辺まだ文字列
        @mark_base = @hand.gsub(/\d/,"")
        @mark = @mark_base.split
        #@hand_mark = [H, D, S, D, S] みたいになる。
        @mark_pairs_hash = @mark.group_by(&:itself).transform_values(&:size)
        #{H=>1, D=>2, S=>2}みたいになる。マークごとの枚数を数える。
        @marks_pairs = @mark_pairs_hash.map{ |_, value| value }
        #[1, 2, 2]みたいになる。同じマークの枚数を配列にする。

        #＝＝＝エラー判定＝＝＝#＝＝＝＝＝＝#＝＝＝＝＝＝＝#＝＝＝＝＝＝＝#＝＝＝＝＝＝＝#
        @hand_empty = @hand_num.gsub(/\d/,"")
        puts @hand_empty
        #文字列から半角数字を消す。
        @hand_ary = @hand.split
        puts @hand_ary
        #文字列@handを、そのまま配列にする。

        if /\d{3,}/=~ @hand_num ||
         #3桁以上の数字があったらとりあえずはじく。以下全部１桁または２桁に関しての話。
           /(?<!S|H|D|C|1)1/=~ @hand ||
           /(?<!S|H|D|C|1)2/=~ @hand ||
           /(?<!S|H|D|C|1)3/=~ @hand ||
           /(?<!S|H|D|C)4/=~ @hand ||
           /(?<!S|H|D|C)5/=~ @hand ||
           /(?<!S|H|D|C)6/=~ @hand ||
           /(?<!S|H|D|C)7/=~ @hand ||
           /(?<!S|H|D|C)8/=~ @hand ||
           /(?<!S|H|D|C)9/=~ @hand ||
           /(?<!1)0/=~ @hand ||
           @hand_empty.match?(/\S/)
          puts "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"

        elsif (@hand_ary.count - @hand_ary.uniq.count) > 0
          puts "カードが重複しています。"

        elsif @hand_ary.size != 5 ||
           @hand.start_with?(" ")||
           @hand.end_with?(" ")||
           @hand_empty != "    "
            puts '5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"）'


      #＝＝＝ここまでエラー判定＝＝＝#＝＝＝＝＝＝#＝＝＝＝＝＝＝#＝＝＝＝＝＝＝#＝＝＝＝＝＝＝#

        elsif @num_forstraight[0] == @num_forstraight[1] + 1 &&
         @num_forstraight[1] + 1 == @num_forstraight[2] + 2 &&
         @num_forstraight[2] + 2 == @num_forstraight[3] + 3 &&
         @num_forstraight[3] + 3 == @num_forstraight[4] + 4 &&
         @marks_pairs.max{|a, b| a.to_f <=> b.to_f} == 5
          #最後の条件文は、配列中の最大値が５＝「同じマークが５枚ある」ことを示している。
          puts "ストレートフラッシュ！！最強！"

        elsif @num_forstraight == [13,12,11,10,1] &&
         @marks_pairs.max{|a, b| a.to_f <=> b.to_f} == 5
          puts "ストレートフラッシュ！！最強！"

        elsif @nums_pairs == [4,1]
          puts "フォー・オブ・ア・カインドだ！強いね！"

        elsif @nums_pairs == [3,2]
          puts "フルハウスだ！かっこいい！"

        elsif @marks_pairs.max{|a, b| a.to_f <=> b.to_f} == 5
          puts "フラッシュ！いけてる！"

        elsif @num_forstraight[0] == @num_forstraight[1] + 1 &&
         @num_forstraight[1] + 1 == @num_forstraight[2] + 2 &&
         @num_forstraight[2] + 2 == @num_forstraight[3] + 3 &&
         @num_forstraight[3] + 3 == @num_forstraight[4] + 4
          puts "ストレート！いけてる！"

        elsif @num_forstraight == [14,5,4,3,2]
          puts "ストレート！いけてる！"

        elsif @nums_pairs == [3,1,1]
          puts "スリー・オブ・ア・カインドだね！いいね！"

        elsif @nums_pairs == [2,2,1]
          puts "ツーペアだね！いいね！"

        elsif  @nums_pairs == [2,1,1,1]
          puts "ワンペアだね！いいね！"

        else
          puts "ハイカード"
        end


  end#defのend



end#classのend
