# frozen_string_literal: true

class CoronavirusForm::HotelRoomsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper
  include FormFlowHelper

  before_action :check_first_question_answered, only: :show

  def show
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    hotel_rooms = sanitize(params[:hotel_rooms]).presence
    session[:hotel_rooms] = hotel_rooms

    invalid_fields = validate_radio_field(
      PAGE,
      radio: hotel_rooms,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      render "coronavirus_form/#{PAGE}"
    elsif session["check_answers_seen"]
      redirect_to controller: "coronavirus_form/check_answers", action: "show"
    else
      redirect_to controller: "coronavirus_form/offer_transport", action: "show"
    end
  end

private

  PAGE = "hotel_rooms"

  def previous_path
    medical_equipment_path
  end
end
