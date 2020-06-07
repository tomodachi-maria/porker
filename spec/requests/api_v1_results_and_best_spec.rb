require 'rails_helper'
include FixedMessages
RSpec.describe "ResultsAndBest", type: :request do

  describe "HTTPコード200系" do
    context "正しい手札のみ送られてきたとき" do
      before do
        sample = {"cards": ["D2 S3 D3 D11 C2","H1 H4 H5 H11 H10"]}
        post "/api/v1/cards/check", params: sample
        @json = JSON.parse(response.body)
      end
      it "HTTPメソッド201が返ること" do
        expect(response).to have_http_status(201)
      end
      it "resultに正しい値が入っていること" do
        #card,hand,best,に値が入っていることを一気にexpectする。
        expect(@json["result"][0]["card"]).to eq ("D2 S3 D3 D11 C2")
        expect(@json["result"][0]["hand"]).to eq (RESULT_TWO_PAIR)
        expect(@json["result"][0]["best"]).to eq (false)
        expect(@json["result"][1]["card"]).to eq ("H1 H4 H5 H11 H10")
        expect(@json["result"][1]["hand"]).to eq (RESULT_FLASH)
        expect(@json["result"][1]["best"]).to eq (true)
      end
    end

    context "エラーを含んだ手札のみ送られてきたとき" do
      before do
        sample = {"cards": ["D 3 D3 D11 C2","H1 H5 H11 H10"]}
        post "/api/v1/cards/check", params: sample
        @json = JSON.parse(response.body)
      end
      it "HTTPメソッド201が返ること" do
         expect(response).to have_http_status(201)
      end
      it "errorに正しい値が入っていること" do
        #card,msgに値が入っていることを一気にexpectする。
        expect(@json["error"][0]["card"]).to eq ("D 3 D3 D11 C2")
        expect(@json["error"][0]["msg"]).to match ["1#{ERROR2_WHERE_IS_WRONG}(D)","2#{ERROR2_WHERE_IS_WRONG}(3)",ERROR2_UNSUITABLE]
        expect(@json["error"][1]["card"]).to eq ("H1 H5 H11 H10")
        expect(@json["error"][1]["msg"]).to match ERROR1_NOT_FIVE_CARDS
      end
    end

    context "正しい手札・エラーを含んだ手札の両方があるとき" do
      before do
        sample = {"cards": ["D2 S3 D3 D11 C2","H1 H5 H11 H10"]}
        post "/api/v1/cards/check", params: sample
        @json = JSON.parse(response.body)
      end
      it "HTTPメソッド201が返ること" do
         expect(response).to have_http_status(201)
      end
      it "resultに正しい値が入っていること" do
        #card,hand,best,に値が入っていることを一気にexpectする。
        expect(@json["result"][0]["card"]).to eq ("D2 S3 D3 D11 C2")
        expect(@json["result"][0]["hand"]).to eq (RESULT_TWO_PAIR)
        expect(@json["result"][0]["best"]).to eq (true)
      end
      it "errorに正しい値が入っていること" do
        #card,msgに値が入っていることを一気にexpectする。
        expect(@json["error"][0]["card"]).to eq ("H1 H5 H11 H10")
        expect(@json["error"][0]["msg"]).to match ERROR1_NOT_FIVE_CARDS
      end
    end
  end


  describe "HTTPコード404系" do
    context "POST リクエストでないとき" do
      before do
        sample = {"cards": ["D2 S3 D3 D11 C2","H1 H5 H11 H10"]}
        get "/api/v1/cards/check", params: sample
        @json = JSON.parse(response.body)
      end
      it "HTTPメソッド404が返ること" do
        expect(response).to have_http_status(404)
      end
      it "errorに正しい値が入っていること" do
      #msgに正しい値が入っている。
        expect(@json["error"][0]["msg"]).to eq (API_ERROR_404)
      end
    end
    context "URLが不正なとき" do
      before do
        sample = {"cards": ["D2 S3 D3 D11 C2","H1 H5 H11 H10"]}
        post "/api/v1/cards/chec", params: sample
        @json = JSON.parse(response.body)
      end
      it "HTTPメソッド404が返ること" do
        expect(response).to have_http_status(404)
      end
      it "errorに正しい値が入っていること" do
        #card,msgに値が入っていることを一気にexpectする。
        expect(@json["error"][0]["msg"]).to eq (API_ERROR_404)
      end
    end
  end


  describe "HTTPコード400系" do
    context "paramsがcardsでないとき" do
      before do
        sample = {"cars": ["D2 S3 D3 D11 C2","H1 H4 H5 H11 H10"]}
        post "/api/v1/cards/check", params: sample
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
        sample = '{"carsd": ["D2 S3 D3 D11 C2","H1 H4 H5 H11 H10"]}'
        post "/api/v1/cards/check", params: sample
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
