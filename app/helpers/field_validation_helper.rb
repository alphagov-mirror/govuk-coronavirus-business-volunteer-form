# frozen_string_literal: true

module FieldValidationHelper
  def validate_field_response_length(page, fields)
    invalid_fields = []
    fields.each do |field|
      next unless params[field]
      next if params[field].length <= 1000

      invalid_fields << { field: field,
                          text: t("coronavirus_form.questions.#{page}.#{field}.custom_length_error",
                                  default: t("coronavirus_form.errors.field_length_error", field: t("coronavirus_form.questions.#{page}.#{field}.label")).humanize) }
    end
    invalid_fields
  end

  def validate_mandatory_text_fields(page, mandatory_fields)
    invalid_fields = []
    mandatory_fields.each do |field|
      next if params[field].present?

      invalid_fields << { field: field.to_s.sub(".", "_"),
                          text: t("coronavirus_form.questions.#{page}.#{field}.custom_error",
                                  default: t("coronavirus_form.errors.missing_mandatory_text_field", field: t("coronavirus_form.questions.#{page}.#{field}.label")).humanize) }
    end
    invalid_fields
  end

  def validate_radio_field(page, radio:, other: false)
    if radio.blank?
      return [{ field: page.to_s.sub(".", "_"),
                text: t(
                  "coronavirus_form.questions.#{page}.custom_select_error",
                  default: t("coronavirus_form.errors.radio_field", field: t("coronavirus_form.questions.#{page}.title")).humanize,
                ) }]
    end

    if other != false && other.blank? && %w[Yes Other].include?(radio)
      return [{ field: page.to_s,
                text: t(
                  "coronavirus_form.questions.#{page}.custom_enter_error",
                  default: t("coronavirus_form.errors.missing_mandatory_text_field", field: t("coronavirus_form.questions.#{page}.title")).humanize,
                ) }]
    end

    []
  end

  def validate_checkbox_field(page, values:, allowed_values:, other: false, other_field: "other")
    if values.blank? || values.empty?
      return [{ field: page.to_s.sub(".", "_"),
                text: t(
                  "coronavirus_form.questions.#{page}.custom_select_error",
                  default: t("coronavirus_form.errors.checkbox_field", field: t("coronavirus_form.questions.#{page}.title")).humanize,
                ) }]
    end

    if (values - allowed_values).any?
      return [{ field: page.to_s.sub(".", "_"),
                text: t(
                  "coronavirus_form.questions.#{page}.custom_select_error",
                  default: t("coronavirus_form.errors.missing_mandatory_text_field", field: t("coronavirus_form.questions.#{page}.title")).humanize,
                ) }]
    end

    if other != false && other.blank? && values.include?(I18n.t("coronavirus_form.questions.#{page}.options.#{other_field}.label"))
      return [{ field: page.to_s.sub(".", "_"),
                text: t(
                  "coronavirus_form.questions.#{page}.options.#{other_field}.error_message",
                  default: t("coronavirus_form.errors.missing_mandatory_text_field", field: t("coronavirus_form.questions.#{page}.title")).humanize,
                ) }]
    end

    []
  end

  def validate_email_address(field, email_address)
    if email_address =~ /@/
      []
    else
      [{ field: field.to_s.sub(".", "_"), text: t("coronavirus_form.errors.email_format") }]
    end
  end

  def validate_postcode(field, postcode)
    if postcode =~ /^(([A-Z]{1,2}[0-9][A-Z0-9]?|ASCN|STHL|TDCU|BBND|[BFS]IQQ|PCRN|TKCA) ?[0-9][A-Z]{2}|BFPO ?[0-9]{1,4}|(KY[0-9]|MSR|VG|AI)[ -]?[0-9]{4}|[A-Z]{2} ?[0-9]{2}|GE ?CX|GIR ?0A{2}|SAN ?TA1)$/i
      []
    else
      [{ field: field.to_s.sub(".", "_"), text: t("coronavirus_form.errors.postcode_format") }]
    end
  end

  def validate_charge_field(field, value)
    if value.blank?
      return [{
        field: field,
        text: t("coronavirus_form.questions.how_much_charge.custom_select_error"),
      }]
    end

    []
  end
end
