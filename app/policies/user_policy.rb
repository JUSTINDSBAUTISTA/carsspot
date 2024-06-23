class UserPolicy < ApplicationPolicy
  def show?
    user.present? && record == user
  end

  def edit?
    user.present? && record == user
  end

  def update?
    user.present? && record == user
  end
end
