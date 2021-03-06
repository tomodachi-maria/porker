class HomeController < ApplicationController
  def top
  end


  def judge
      @hand = params[:hand]
      puts @hand

    #この辺まだ文字列
      @hand_num = @hand.gsub(/S|H|D|C/, "S" => "", "H" => "", "D" => "", "C" => "")
      #文字列からS/H/D/Cを消して数字だけの文字列に。エラー判定にも利用。
      # "10 1 3 4 1"になる。

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
      #文字列から半角数字を消す。
      @hand_ary = @hand.split
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
         @hand.start_with?(" ")||
         @hand.end_with?(" ")||
         @hand_empty != "    "
        @messages = "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
        render action: :top

      elsif (@hand_ary.count - @hand_ary.uniq.count) > 0
        @messages = "カードが重複しています。"
        render action: :top

      elsif @hand_ary.size != 5
        @messages = '5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"）'
        render action: :top


    #＝＝＝ここまでエラー判定＝＝＝#＝＝＝＝＝＝#＝＝＝＝＝＝＝#＝＝＝＝＝＝＝#＝＝＝＝＝＝＝#

      elsif @num_forstraight[0] == @num_forstraight[1] + 1 &&
       @num_forstraight[1] + 1 == @num_forstraight[2] + 2 &&
       @num_forstraight[2] + 2 == @num_forstraight[3] + 3 &&
       @num_forstraight[3] + 3 == @num_forstraight[4] + 4 &&
       @marks_pairs.max{|a, b| a.to_f <=> b.to_f} == 5
        #最後の条件文は、配列中の最大値が５＝「同じマークが５枚ある」ことを示している。
        @messages = "ストレートフラッシュ！！最強！"
        render action: :top

      elsif @num_forstraight == [13,12,11,10,1] &&
       @marks_pairs.max{|a, b| a.to_f <=> b.to_f} == 5
        @messages = "ストレートフラッシュ！！最強！"
        render action: :top

      elsif @nums_pairs == [4,1]
        @messages = "フォー・オブ・ア・カインドだ！強いね！"
        render action: :top

      elsif @nums_pairs == [3,2]
        @messages = "フルハウスだ！かっこいい！"
        render action: :top

      elsif @marks_pairs.max{|a, b| a.to_f <=> b.to_f} == 5
        render action: :top

      elsif @num_forstraight[0] == @num_forstraight[1] + 1 &&
       @num_forstraight[1] + 1 == @num_forstraight[2] + 2 &&
       @num_forstraight[2] + 2 == @num_forstraight[3] + 3 &&
       @num_forstraight[3] + 3 == @num_forstraight[4] + 4
        @messages = "ストレート！いけてる！"
        render action: :top

      elsif @num_forstraight == [14,5,4,3,2]
        @messages = "ストレート！いけてる！"
        render action: :top

      elsif @nums_pairs == [3,1,1]
        @messages = "スリー・オブ・ア・カインドだね！いいね！"
        render action: :top

      elsif @nums_pairs == [2,2,1]
      @messages = "ツーペアだね！いいね！"
      render action: :top

      elsif  @nums_pairs == [2,1,1,1]
        @messages = "ワンペアだね！いいね！"
        render action: :top

      else
        @messages = "ハイカード"
        render action: :top
      end

  end#defのend



end#classのend
