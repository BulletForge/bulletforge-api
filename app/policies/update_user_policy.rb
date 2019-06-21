# frozen_string_literal: true

class UpdateUserPolicy
  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def authorized?
    current_user.admin?
  end
end
