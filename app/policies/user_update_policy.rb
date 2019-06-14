# frozen_string_literal: true

class UserUpdatePolicy
  attr_reader :current_user, :args

  def initialize(current_user, args)
    @current_user = current_user
    @args = args
  end

  def authorized?
    current_user.admin? || (editing_self? && no_admin_arg?)
  end

  private

  def editing_self?
    current_user.to_param == args[:id]
  end

  def no_admin_arg?
    args[:admin].nil?
  end
end
