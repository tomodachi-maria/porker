require 'rails_helper'
require "cards_controller"
include Check
include FixedMessages

RSpec.describe CardsController, type: :controller do
  render_views
  describe "POST #judge" do
    context "@cards.error != nilだった時" do
      it "error.html.erb viewに遷移するか" do
        post :judge, params: {hand: "S1 S2 S3 S4"}
        expect(response).to render_template ("error")
      end
    end

    context "@cards.error == nilだった時" do
      it "result.html.erb viewに遷移するか" do
        post :judge, params: {hand: "S1 S2 S3 S4 S5"}
        expect(response).to render_template :result
      end
    end
  end
end
