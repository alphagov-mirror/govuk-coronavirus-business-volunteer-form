# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ActionView::Helpers::SanitizeHelper
  include CheckAnswersHelper
  include FieldValidationHelper
  include FormFlowHelper

  rescue_from ActionController::InvalidAuthenticityToken, with: :session_expired

  if ENV["REQUIRE_BASIC_AUTH"]
    http_basic_authenticate_with(
      name: ENV.fetch("BASIC_AUTH_USERNAME"),
      password: ENV.fetch("BASIC_AUTH_PASSWORD"),
    )
  end

  before_action :check_first_question_answered, only: :show
  before_action :set_session_history, only: :show

  def show
    @form_responses = session.to_hash.with_indifferent_access
    render controller_path
  end

private

  helper_method :previous_path

  def set_session_history
    if session[:current_path] != request.path
      session[:previous_path] = session[:current_path]
    end
    session[:current_path] = request.path
  end

  def session_expired
    reset_session
    redirect_to session_expired_path
  end

  def previous_path
    raise NotImplementedError, "Define a previous path"
  end

  def log_validation_error(invalid_fields)
    logger.info do
      {
        validation_error: { text: invalid_fields.pluck(:text).to_sentence },
      }.to_json
    end
  end
end
