require 'rails_helper'
include Check
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
    # before do
    #   post :judge, params: {cards: @sample }
    # end

    context "@cards.error != nilのとき" do
      it "error.html.erb viewに遷移するか" do
        post :judge, params: {cards: "S1 S2 S3 S4"}

        expect(response).to render_template ("error")
        # expect(assigns(:error)).to eq ERROR1_NOT_FIVE_CARDS
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