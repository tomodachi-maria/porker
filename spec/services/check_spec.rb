require "rails_helper"
include Check
include FixedMessages

RSpec.describe HandCheck do
  describe '#check_error' do
    context "ERROR_CARD_SIZEが機能すること" do #contextは条件みたいに書くらしい。#HandCheck.new(変数)は、毎回やるのでbefore do-endすると良い。
      it "/,　_では区切れないこと" do
        cards = HandCheck.new("S1/S2,S3　S4_S5")
        a = cards.cards
        expect(a.split).to be ==["S1/S2,S3　S4_S5"]
      end
      it "文頭/末、および2連続の半角スペースは、1枚に数えられてしまうこと" do
        cards = HandCheck.new(" S1  S2 S3 S4 S5 ")
        a = cards.cards
        expect(a.split(/ /, -1)).to eq ["","S1","","S2","S3","S4","S5",""]
      end
      it "指定したカードが4枚の時にERROR_CARD_SIZEを返すこと" do
        expect(HandCheck.new("S1 S2 S3 S4").check_error).to be == (ERROR_CARD_SIZE)
      end
      it "指定したカードが6枚の時にERROR_CARD_SIZEを返すこと" do
        expect(HandCheck.new("S1 S2 S3 S4 S5 S6").check_error).to be == (ERROR_CARD_SIZE)
      end
    end


    context "ERROR_UNSUITABLEが機能すること" do
      it "小文字のアルファベットが含まれている時にERROR_UNSUITABLEを返すこと" do
        cards= HandCheck.new("s1 S2 S3 S4 S5")
        cards.check_error
        expect(cards.error).to match ["1#{ERROR_WHERE_IS_WRONG}(s1)",ERROR_UNSUITABLE]
      end
      it "SDHC以外のアルファベットが含まれている時にERROR_UNSUITABLEを返すこと" do
        cards= HandCheck.new("A7 C6 C5 C4 C3")
        cards.check_error
        expect(cards.error).to match ["1#{ERROR_WHERE_IS_WRONG}(A7)",ERROR_UNSUITABLE]
      end
      it "1~13以外の数字が含まれている時にERROR_UNSUITABLEを返すこと" do
        cards= HandCheck.new("C14 C6 C5 C4 C3")
        cards.check_error
        expect(cards.error).to match ["1#{ERROR_WHERE_IS_WRONG}(C14)",ERROR_UNSUITABLE]
      end
      it "不正なカード指定が2枚以上あった時に全ての不正箇所を返すこと" do
        cards= HandCheck.new("C14 C6 C5 s4 C3")
        cards.check_error
        expect(cards.error).to match ["1#{ERROR_WHERE_IS_WRONG}(C14)","4#{ERROR_WHERE_IS_WRONG}(s4)",ERROR_UNSUITABLE]
      end
    end

    context "ERROR_SAME_CARDSが機能すること" do
      it "カードが重複している時にERROR_SAME_CARDSを返すこと" do
        cards= HandCheck.new("D1 D1 D3 D4 D5")
        cards.check_error
        expect(cards.error).to be == (ERROR_SAME_CARDS)
      end
    end

    context "CARD_SIZE>UNSUITABLE>SAME_CARDSの優先順位でエラー文が返ってくること" do
      it "CARD_SIZE>UNSUITABLEの優先順位であること" do
        cards= HandCheck.new("s1 D3 D4 D5")
        cards.check_error
        expect(cards.error).to be == (ERROR_CARD_SIZE)
      end
      it "CARD_SIZE>UNSUITABLEの優先順位であること" do
        cards= HandCheck.new("s1 D3 D4 D5 D5")
        cards.check_error
        expect(cards.error).to match ["1#{ERROR_WHERE_IS_WRONG}(s1)",ERROR_UNSUITABLE]
      end
    end
  end


  describe "#check_result" do
      it "10~13,1の場合のストレートフラッシュが正しく判定されること" do
        cards = HandCheck.new("S10 S11 S12 S13 S1")
        cards.check_result
        expect(cards.hand).to be ==(RESULT_STRAIGHT_FLASH)
      end
      it "1~13の場合のストレートフラッシュが正しく判定されること" do
        cards = HandCheck.new("S10 S11 S12 S13 S1")
        cards.check_result
        expect(cards.hand).to be ==(RESULT_STRAIGHT_FLASH)
      end
      it "フォー・オブ・ア・カインドが正しく判定されること" do
        cards = HandCheck.new("D6 H6 S6 C6 S13")
        cards.check_result
        expect(cards.hand).to be ==(RESULT_FOUR_OF_A_KIND)
      end
      it "フルハウスが正しく判定されること" do
        cards = HandCheck.new("S10 H10 D10 S4 D4")
        cards.check_result
        expect(cards.hand).to be ==(RESULT_FULLHOUSE)
      end
      it "フラッシュが正しく判定されること" do
        cards = HandCheck.new("H1 H12 H10 H5 H3")
        cards.check_result
        expect(cards.hand).to be ==(RESULT_FLASH)
      end
      it "10~13,1の場合のストレートが正しく判定されること" do
        cards = HandCheck.new("S10 S11 H12 H13 S1")
        cards.check_result
        expect(cards.hand).to be ==(RESULT_STRAIGHT)
      end
      it "1~13の場合のストレートが正しく判定されること" do
        cards = HandCheck.new("S8 S7 H6 H5 S4")
        cards.check_result
        expect(cards.hand).to be ==(RESULT_STRAIGHT)
      end
      it "スリー・オブ・ア・カインドが正しく判定されること" do
        cards = HandCheck.new("S12 C12 D12 S5 C3")
        cards.check_result
        expect(cards.hand).to be ==(RESULT_THREE_OF_A_KIND)
      end
      it "ツーペアが正しく判定されること" do
        cards = HandCheck.new("H13 D13 C2 D2 H11")
        cards.check_result
        expect(cards.hand).to be ==(RESULT_TWO_PAIR)
      end
      it "ワンペアが正しく判定されること" do
        cards = HandCheck.new("C10 S10 S6 H4 H2")
        cards.check_result
        expect(cards.hand).to be ==(RESULT_ONE_PAIR)
      end
      it "ハイカードが正しく判定されること" do
        cards = HandCheck.new("D1 D10 S9 C5 C4")
        cards.check_result
        expect(cards.hand).to be ==(RESULT_HIGH_CARD)
      end
  end
end
