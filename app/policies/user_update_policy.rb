# frozen_string_literal: true

class UserUpdatePolicy
  attr_reader :current_user, :args

  def initialize(current_user, args)
    @current_user = current_user
    @args = args
  end

  def authorized?
    current_user.admin? || (editing_self? && !admin_arg?)
  end

  private

  def editing_self?
    current_user.friendly_id == args[:id]
  end

  def admin_arg?
    args.keys.include?(:admin)
  end
end
