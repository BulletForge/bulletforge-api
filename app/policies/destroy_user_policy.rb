# frozen_string_literal: true

class DestroyUserPolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def authorized?
    current_user.admin? || destroying_self?
  end

  private

  def destroying_self?
    current_user.id == user.id
  end
end
