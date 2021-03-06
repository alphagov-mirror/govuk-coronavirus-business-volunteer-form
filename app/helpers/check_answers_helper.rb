module CheckAnswersHelper
  def sections_scope
    "coronavirus_form.check_your_answers.sections"
  end

  def charge_text
    I18n.t("coronavirus_form.check_your_answers.charge")
  end

  def question_items(question)
    if session[question].is_a?(Array)
      [{
        field: I18n.t("coronavirus_form.questions.#{question}.title"),
        value: render("govuk_publishing_components/components/list", {
          visible_counters: true,
          items: session[question],
        }),
      }]
    else
      [{
        field: I18n.t("coronavirus_form.questions.#{question}.title"),
        value: session[question],
      }]
    end
  end

  def sections
    %w[
      accommodation
      transport
      space
      staff
      care
      services
      other_support
      location
      business_details
      contact_details
    ]
  end

  def accommodation_items
    [
      {
        field: I18n.t("accommodation.type", scope: sections_scope),
        value: session[:rooms_number],
      },
      {
        field: I18n.t("accommodation.description", scope: sections_scope),
        value: session[:accommodation_description],
      },
      {
        field: charge_text,
        value: session[:accommodation_cost],
      },
    ]
  end

  def transport_items
    [
      {
        field: I18n.t("transport.type", scope: sections_scope),
        value: render("govuk_publishing_components/components/list", {
          visible_counters: true,
          items: session[:transport_type],
        }),
      },
      {
        field: I18n.t("transport.description", scope: sections_scope),
        value: session[:transport_description],
      },
      {
        field: charge_text,
        value: session[:transport_cost],
      },
    ]
  end

  def space_items
    [
      {
        field: I18n.t("space.type", scope: sections_scope),
        value: render("govuk_publishing_components/components/list", {
          visible_counters: true,
          items: space_item_value_list,
        }),
      },
      {
        field: I18n.t("space.description", scope: sections_scope),
        value: session[:general_space_description],
      },
      {
        field: charge_text,
        value: session[:space_cost],
      },
    ]
  end

  def space_item_value_list
    session[:offer_space_type].map do |item|
      case item
      when "Warehouse space"
        value = session[:warehouse_space_description]
      when "Office space"
        value = session[:office_space_description]
      when "Other"
        value = session[:offer_space_type_other]
      end

      delimited_number = number_with_delimiter(value.to_i, delimiter: ",")
      "#{item} (#{pluralize(delimited_number, 'square foot')})"
    end
  end

  def staff_items
    [
      {
        field: I18n.t("staff.type", scope: sections_scope),
        value: render("govuk_publishing_components/components/list", {
          visible_counters: true,
          items: staff_item_value_list,
        }),
      },
      {
        field: I18n.t("staff.description", scope: sections_scope),
        value: session[:offer_staff_description],
      },
      {
        field: charge_text,
        value: session[:offer_staff_charge],
      },
    ]
  end

  def staff_item_value_list
    session[:offer_staff_type].map do |item|
      case item
      when "Cleaners"
        value = session.dig(:offer_staff_number, :cleaners_number)
      when "Developers"
        value = session.dig(:offer_staff_number, :developers_number)
      when "Medical staff"
        value = session.dig(:offer_staff_number, :medical_staff_number)
      when "Office staff"
        value = session.dig(:offer_staff_number, :office_staff_number)
      when "Security staff"
        value = session.dig(:offer_staff_number, :security_staff_number)
      when "Trainers or coaches"
        value = session.dig(:offer_staff_number, :trainers_number)
      when "Translators"
        value = session.dig(:offer_staff_number, :translators_number)
      when "Other staff"
        value = session.dig(:offer_staff_number, :other_staff_number)
      end

      delimited_number = number_with_delimiter(value.to_i, delimiter: ",")
      "#{item} (#{pluralize(delimited_number, 'person')})"
    end
  end

  def care_items
    [
      {
        field: I18n.t("care.type", scope: sections_scope),
        value: render("govuk_publishing_components/components/list", {
          visible_counters: true,
          items: session[:offer_care_type],
        }),
      },
      {
        field: I18n.t("care.qualifications", scope: sections_scope),
        value: render("govuk_publishing_components/components/list", {
          visible_counters: true,
          items: session[:offer_care_qualifications],
        }),
      },
      {
        field: charge_text,
        value: session[:care_cost],
      },
    ]
  end

  def construction_service_items
    [
      {
        field: I18n.t("services.construction.type", scope: sections_scope),
        value: render("govuk_publishing_components/components/list", {
          visible_counters: true,
          items: session[:construction_services],
        }),
      },
      {
        field: I18n.t("services.construction.description", scope: sections_scope),
        value: session[:construction_services_other],
      },
      {
        field: charge_text,
        value: session[:construction_cost],
      },
    ]
  end

  def it_service_items
    [
      {
        field: I18n.t("services.it.type", scope: sections_scope),
        value: render("govuk_publishing_components/components/list", {
          visible_counters: true,
          items: session[:it_services],
        }),
      },
      {
        field: I18n.t("services.it.description", scope: sections_scope),
        value: session[:it_services_other],
      },
      {
        field: charge_text,
        value: session[:it_cost],
      },
    ]
  end

  def other_support_items
    [{
      field: t("other_support.description", scope: sections_scope),
      value: session["offer_other_support"],
    }]
  end

  def location_items
    [{
      field: t("location.description", scope: sections_scope),
      value: render("govuk_publishing_components/components/list", {
        visible_counters: true,
        items: session[:location],
      }),
    }]
  end

  def business_detail_items
    [
      {
        field: I18n.t("business_details.name", scope: sections_scope),
        value: session.dig(:business_details, :company_name),
      },
      {
        field: I18n.t("business_details.number", scope: sections_scope),
        value: session.dig(:business_details, :company_number),
      },
      {
        field: I18n.t("business_details.size", scope: sections_scope),
        value: session.dig(:business_details, :company_size),
      },
      {
        field: I18n.t("business_details.location", scope: sections_scope),
        value: business_detail_location,
      },
    ]
  end

  def business_detail_location
    if session.dig(:business_details, :company_postcode).present?
      "#{session.dig(:business_details, :company_location)} (#{session.dig(:business_details, :company_postcode)})"
    else
      session.dig(:business_details, :company_location)
    end
  end

  def contact_detail_items
    [
      {
        field: t("contact_details.name", scope: sections_scope),
        value: session.dig(:contact_details, :contact_name),
      },
      {
        field: t("contact_details.role", scope: sections_scope),
        value: session.dig(:contact_details, :role),
      },
      {
        field: t("contact_details.number", scope: sections_scope),
        value: session.dig(:contact_details, :phone_number),
      },
      {
        field: t("contact_details.email", scope: sections_scope),
        value: session.dig(:contact_details, :email),
      },
    ]
  end
end
