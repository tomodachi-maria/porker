require 'rails_helper'
require_relative "../../app/services/fixed_messages"
include FixedMessages

RSpec.describe "Cards", type: :request do
  let(:url){"/api/v1/cards/check"}
  let(:cards){@params}
  describe "HTTPコード200系" do
    context "強さの異なる正しい手札のみが送られてきたとき" do
      before do
        @params = {"cards": ["D2 S3 D3 D11 C2","H1 H4 H5 H11 H10"]}
        post url, params: cards
        @json = JSON.parse(response.body)
      end
      it "HTTPメソッド201が返ること" do
        expect(response).to have_http_status(201)
      end
      it "resultに正しい値が入っていること" do
        expect(@json["result"][0]["card"]).to eq ("D2 S3 D3 D11 C2")
        expect(@json["result"][0]["hand"]).to eq (RESULT_TWO_PAIR)
        expect(@json["result"][0]["best"]).to eq (false)
        expect(@json["result"][1]["card"]).to eq ("H1 H4 H5 H11 H10")
        expect(@json["result"][1]["hand"]).to eq (RESULT_FLASH)
        expect(@json["result"][1]["best"]).to eq (true)
      end
    end

    context "強さが等しい正しい手札のみが送られてきたとき" do
      before do
        @params = {"cards": ["S2 S3 S4 S5 S6","H1 H10 H11 H12 H13"]}
        post url, params: cards
        @json = JSON.parse(response.body)
      end
      it "HTTPメソッド201が返ること" do
        expect(response).to have_http_status(201)
      end
      it "resultに正しい値が入っていること" do
        expect(@json["result"][0]["card"]).to eq ("S2 S3 S4 S5 S6")
        expect(@json["result"][0]["hand"]).to eq (RESULT_STRAIGHT_FLASH)
        expect(@json["result"][0]["best"]).to eq (true)
        expect(@json["result"][1]["card"]).to eq ("H1 H10 H11 H12 H13")
        expect(@json["result"][1]["hand"]).to eq (RESULT_STRAIGHT_FLASH)
        expect(@json["result"][1]["best"]).to eq (true)
      end
    end

    context "エラーを含んだ手札のみ送られてきたとき" do
      before do
        @params = {"cards": ["D 3 D3 D11 C2","H1 H5 H11 H10"]}
        post url, params: cards
        @json = JSON.parse(response.body)
      end
      it "HTTPメソッド201が返ること" do
         expect(response).to have_http_status(201)
      end
      it "errorに正しい値が入っていること" do
        expect(@json["error"][0]["card"]).to eq ("D 3 D3 D11 C2")
        expect(@json["error"][0]["msg"]).to match ["1#{ERROR_WHERE_IS_WRONG}(D)","2#{ERROR_WHERE_IS_WRONG}(3)",ERROR_UNSUITABLE]
        expect(@json["error"][1]["card"]).to eq ("H1 H5 H11 H10")
        expect(@json["error"][1]["msg"]).to match ERROR_CARD_SIZE
      end
    end

    context "正しい手札・エラーを含んだ手札の両方があるとき" do
      before do
        @params = {"cards": ["D2 S3 D3 D11 C2","H1 H5 H11 H10"]}
        post url, params: cards
        @json = JSON.parse(response.body)
      end
      it "HTTPメソッド201が返ること" do
         expect(response).to have_http_status(201)
      end
      it "resultに正しい値が入っていること" do
        expect(@json["result"][0]["card"]).to eq ("D2 S3 D3 D11 C2")
        expect(@json["result"][0]["hand"]).to eq (RESULT_TWO_PAIR)
        expect(@json["result"][0]["best"]).to eq (true)
      end
      it "errorに正しい値が入っていること" do
        expect(@json["error"][0]["card"]).to eq ("H1 H5 H11 H10")
        expect(@json["error"][0]["msg"]).to match ERROR_CARD_SIZE
      end
    end
  end


  describe "HTTPコード404系" do
    @sample = {"cards": ["D2 S3 D3 D11 C2","H1 H5 H11 H10"]}
    context "POST リクエストでないとき" do
      before do
        get url, params: cards
        @json = JSON.parse(response.body)
      end
      it "HTTPメソッド404が返ること" do
        expect(response).to have_http_status(404)
      end
      it "errorに正しい値が入っていること" do
        expect(@json["error"][0]["msg"]).to eq (API_ERROR_404)
      end
    end

    context "URLが不正なとき" do
      before do
        post "/api/v1/cards/aaaaa", params:cards
        @json = JSON.parse(response.body)
      end
      it "HTTPメソッド404が返ること" do
        expect(response).to have_http_status(404)
      end
      it "errorに正しい値が入っていること" do
        expect(@json["error"][0]["msg"]).to eq (API_ERROR_404)
      end
    end
  end

  describe "HTTPコード400系" do
    context "paramsがcardsでないとき" do
      before do
        post url, params: {"aaaa": ["D2 S3 D3 D11 C2","H1 H4 H5 H11 H10"]}
        @json = JSON.parse(response.body)
      end
      it "HTTPメソッド400が返ること" do
        expect(response).to have_http_status(400)
      end
      it "errorに正しい値が入っていること" do
        expect(@json["error"][0]["msg"]).to eq (API_ERROR_400)
      end
    end

    context "paramsがJOSN形式でないとき" do
      before do
        post url, params: '{"carsd": ["D2 S3 D3 D11 C2","H1 H4 H5 H11 H10"]}'
        @json = JSON.parse(response.body)
      end
      it "HTTPメソッド400が返ること" do
        expect(response).to have_http_status(400)
      end
      it "errorに正しい値が入っていること" do
        expect(@json["error"][0]["msg"]).to eq (API_ERROR_400)
      end
    end
  end
end
