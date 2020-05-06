module FormResponseHelper
  def valid_data
    {
      medical_equipment: I18n.t("coronavirus_form.questions.medical_equipment.options").map { |_, item| item[:label] }.sample,
      accommodation: I18n.t("coronavirus_form.questions.accommodation.options").map { |_, item| item[:label] }.sample,
      rooms_number: "40",
      offer_transport: I18n.t("coronavirus_form.questions.offer_transport.options").map { |_, item| item[:label] }.sample,
      transport_type: I18n.t("coronavirus_form.questions.transport_type.options").map { |_, item| item[:label] },
      transport_description: "10 trucks",
      transport_cost: I18n.t("coronavirus_form.questions.how_much_charge.options").map { |_, item| item[:label] }.sample,
      offer_space: I18n.t("coronavirus_form.questions.offer_space.options").map { |_, item| item[:label] }.sample,
      offer_space_type: I18n.t("coronavirus_form.questions.offer_space_type.options").map { |_, item| item[:label] },
      warehouse_space_description: "5000",
      office_space_description: "6000",
      general_space_description: "Multiple units.",
      offer_space_type_other: "10000",
      expert_advice_type: I18n.t("coronavirus_form.questions.expert_advice_type.options").map { |_, item| item[:label] },
      expert_advice_type_other: "Life coach",
      offer_care: I18n.t("coronavirus_form.questions.offer_care.options").map { |_, item| item[:label] }.sample,
      offer_care_type: I18n.t("coronavirus_form.questions.offer_care_qualifications.offer_care_type.options").map { |_, item| item[:label] },
      offer_care_qualifications: I18n.t("coronavirus_form.questions.offer_care_qualifications.care_qualifications.options").map { |_, item| item[:label] },
      offer_care_qualifications_type: "Nursing degree",
      offer_other_support: "All the support, all the time!",
      business_details: {
        company_name: "Mandalore Inc.",
        company_number: "12345678",
        company_size: I18n.t("coronavirus_form.questions.business_details.company_size.options.under_50_people.label"),
        company_location: I18n.t("coronavirus_form.questions.business_details.company_location.options.united_kingdom.label"),
        company_postcode: "E1 8QS",
      },
      contact_details: {
        contact_name: "Satine Kryze",
        role: "Leader",
        phone_number: "0123456789",
        email: "me@example.com",
      },
      product_details: [
        {
          product_id: SecureRandom.uuid,
          medical_equipment_type: I18n.t("coronavirus_form.questions.medical_equipment_type.options.number_testing_equipment.label"),
        },
        {
          product_id: SecureRandom.uuid,
          medical_equipment_type: I18n.t("coronavirus_form.questions.medical_equipment_type.options.number_ppe.label"),
        },
        {
          lead_time: "12",
          product_id: SecureRandom.uuid,
          product_url: "http://www.example.com",
          product_cost: "1",
          product_name: "Surgical Gloves",
          equipment_type: I18n.t("coronavirus_form.questions.product_details.equipment_type.options").map { |_, item| item[:label] }.sample,
          product_location: I18n.t("coronavirus_form.questions.product_details.product_location.options").map { |_, item| item[:label] }.sample,
          product_postcode: "E1 8QS",
          product_quantity: "10000",
          certification_details: "None",
          medical_equipment_type: I18n.t("coronavirus_form.questions.medical_equipment_type.options.number_ppe.label"),
        },
      ],
      are_you_a_manufacturer: I18n.t("coronavirus_form.questions.are_you_a_manufacturer.options").map { |_, item| item[:label] },
      additional_product: I18n.t("coronavirus_form.questions.additional_product.options").map { |_, item| item[:label] }.sample,
      check_answers_seen: true,
      location: I18n.t("coronavirus_form.questions.location.options").map { |_, item| item[:label] },
    }
  end
end
