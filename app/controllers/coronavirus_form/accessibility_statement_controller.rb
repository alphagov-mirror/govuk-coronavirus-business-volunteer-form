# frozen_string_literal: true

class CoronavirusForm::AccessibilityStatementController < ApplicationController
  skip_before_action :check_first_question_answered
end
