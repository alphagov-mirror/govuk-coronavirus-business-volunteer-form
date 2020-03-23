# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::OfferTransportController, type: :controller do
  let(:current_template) { "coronavirus_form/offer_transport" }
  let(:session_key) { :offer_transport }

  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template(current_template)
    end
  end

  describe "POST submit" do
    let(:selected_yes) { I18n.t("coronavirus_form.offer_transport.options.option_yes.label") }
    let(:selected_no) { I18n.t("coronavirus_form.offer_transport.options.option_no.label") }

    it "sets session variables" do
      post :submit, params: { offer_transport: selected_yes }
      expect(session[session_key]).to eq selected_yes
    end

    it "redirects to next step for a YES response" do
      post :submit, params: { offer_transport: selected_yes }
      expect(response).to redirect_to(what_kind_of_transport_path)
    end

    it "redirects to next step for a NO response" do
      post :submit, params: { offer_transport: selected_no }
      expect(response).to redirect_to(offer_space_path)
    end

    it "redirects to check your answers if check your answers previously seen" do
      session[:check_answers_seen] = true
      post :submit, params: { offer_transport: [selected_yes, selected_no].sample }

      expect(response).to redirect_to(check_your_answers_path)
    end

    it "validates any option is chosen" do
      post :submit, params: { offer_transport: "" }

      expect(response).to render_template(current_template)
    end

    it "validates a valid option is chosen" do
      post :submit, params: { offer_transport: "<script></script>" }

      expect(response).to render_template(current_template)
    end
  end
end
