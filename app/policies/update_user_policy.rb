# frozen_string_literal: true

class UpdateUserPolicy
  attr_reader :current_user, :user, :args

  def initialize(current_user, user, args)
    @current_user = current_user
    @user = user
    @args = args
  end

  def authorized?
    current_user.admin? || (editing_self? && !passing_admin_arg?)
  end

  private

  def editing_self?
    current_user.id == user.id
  end

  def passing_admin_arg?
    args.keys.include?(:admin)
  end
end
