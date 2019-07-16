# frozen_string_literal: true

class UpdateProjectPolicy
  attr_reader :current_user, :project

  def initialize(current_user, project)
    @current_user = current_user
    @project = project
  end

  def authorized?
    admin? || owns_project?
  end

  def admin?
    current_user.admin?
  end

  def owns_project?
    project.user_id == current_user.id
  end
end
