require 'rails_helper'
include HandCheckModule
include FixedMessages

RSpec.describe CardsController, type: :controller do
  render_views
  describe "GET #top" do
    before do
      get :top
    end
      it "top.html.erb viewに遷移するか" do
        expect(response).to render_template :top
      end
      it "ステータスコード200を返す" do
        expect(response).to have_http_status 200
      end
  end

  describe "POST #judge" do
    context "@cards.error != nilのとき" do
      before do
        post :judge, params: {cards: "S1 S2 S3 S4"}
      end
      it "error.html.erb viewに遷移するか" do
        expect(response).to render_template ("error")
      end
      it "ステータスコード200を返す" do
        expect(response).to have_http_status 200
      end
    end

    context "@cards.error == nilだったとき" do
      before do
        post :judge, params: {cards: "S1 S2 S3 S4 S5"}
      end
      it "result.html.erb viewに遷移するか" do
         expect(response).to render_template :result
      end
      it "ステータスコード200を返す" do
        expect(response).to have_http_status 200
      end
    end
  end
end
