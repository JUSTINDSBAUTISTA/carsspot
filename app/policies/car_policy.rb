class CarPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end

  def show?
    record.user == user || user.admin? || record.status == 'approved'
  end

  def create?
    user.present?
  end

  def update?
    record.user == user || user.admin?
  end

  def destroy?
    record.user == user || user.admin?
  end

  def approve?
    user.admin?
  end

  def reject?
    user.admin?
  end

  def my_cars?
    user.present?
  end

  def pending_approval?
    user.admin?
  end
end
