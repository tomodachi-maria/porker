require 'rails_helper'
require "cards_controller"
include Check

RSpec.describe CardsController do

  describe "#judge" do
    context "@cards.error != nilだった時" do
      it "error.html.erb　viewに遷移するか" do
        #expect(response).to render_template :error
      end
      it "@errorにエラー文が入っているか" do
      end
    end

    context "@cards.error == nilだった時" do
      it "result.html.erb　viewに遷移するか" do
      end
      it "@resultに役判定結果が入っているか" do
      end
    end

  end


end
