require 'rails_helper'
include Check
include FixedMessages

RSpec.describe CardsController, type: :controller do #require "cards_controller"は、ここであるから要らない。
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
    before do
      post :judge, params: {cards: @sample }
    end

    context "@cards.error != nilだった時" do
      it "error.html.erb viewに遷移するか" do
        @sample = "S1 S2 S3 S4"
        expect(response).to render_template ("error")
      end
    end

    # context "@cards.error == nilだった時" do
    #   it "result.html.erb viewに遷移するか" do
    #      @sample = "S1 S2 S3 S4 S5"
    #      expect(response).to render_template :result
    #   end

      it "ステータスコード200を返す" do
        @sample = "S1 S2 S3 S4 S5"
        expect(response).to have_http_status 200
      end
    end
  end
