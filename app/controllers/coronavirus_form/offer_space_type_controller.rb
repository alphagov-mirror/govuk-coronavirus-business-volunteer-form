# frozen_string_literal: true

class CoronavirusForm::OfferSpaceTypeController < ApplicationController
  OPTIONS = I18n.t("coronavirus_form.questions.#{controller_name}.options")
  ALLOWED_VALUES = OPTIONS.map { |_, item| item.dig(:label) }
  TEXT_FIELDS = [:general_space_description].freeze
  DESCRIPTION_FIELDS = OPTIONS.map { |_, item| item.dig(:description, :id) }.freeze

  def submit
    offer_space_type = Array(params[:offer_space_type]).map { |item| strip_tags(item).presence }.compact
    session[:offer_space_type] = offer_space_type
    session[:offer_space_type_other] = description(:other, offer_space_type)
    session[:warehouse_space_description] = description(:warehouse_space, offer_space_type)
    session[:office_space_description] = description(:office_space, offer_space_type)
    session[:general_space_description] = strip_tags(params[:general_space_description]).presence

    invalid_fields = validate_fields(offer_space_type)

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render controller_path
    elsif session["check_answers_seen"]
      redirect_to check_your_answers_url
    else
      redirect_to expert_advice_type_url
    end
  end

private

  def validate_fields(offer_space_type)
    [
      validate_field_response_length(controller_name, TEXT_FIELDS),
      validate_checkbox_field(controller_name, values: offer_space_type, allowed_values: ALLOWED_VALUES),
      validate_mandatory_text_fields(controller_name, TEXT_FIELDS),
      validate_description_fields(offer_space_type),
      validate_descriptions_response_length(offer_space_type),
    ].flatten.compact
  end

  def validate_descriptions_response_length(_selected_options)
    overlong_descriptions.map do |(option_id, option)|
      {
        field: option.dig(:description, :id).to_s,
        text: t("coronavirus_form.questions.#{controller_name}.options.#{option_id}.description.custom_length_error"),
      }
    end
  end

  def overlong_descriptions
    filter_options do |_field_id, option|
      val = session[option.dig(:description, :id)]
      val.present? && val.length > 1000
    end
  end

  def filter_options(&predicate)
    OPTIONS.to_a.select { |(field_id, option)| predicate.call(field_id, option) }.to_h
  end

  def validate_description_fields(selected_options)
    missing_descriptions(selected_options).map do |field_id, option|
      {
        field: option.dig(:description, :id).to_s,
        text: t("coronavirus_form.questions.#{controller_name}.options.#{field_id}.description.error_message"),
      }
    end
  end

  def missing_descriptions(selected_options)
    filter_options do |field_id, option|
      description_id = option.dig(:description, :id).to_sym
      selected_field?(field_id, selected_options) && session[description_id].blank?
    end
  end

  def description(field, checkboxes)
    if selected_field?(field, checkboxes)
      strip_tags(params[OPTIONS.dig(field, :description, :id)]).presence
    else
      ""
    end
  end

  def selected_field?(field, checkboxes)
    checkboxes.include?(
      I18n.t("coronavirus_form.questions.#{controller_name}.options.#{field}.label"),
    )
  end

  def previous_path
    offer_space_url
  end
end
