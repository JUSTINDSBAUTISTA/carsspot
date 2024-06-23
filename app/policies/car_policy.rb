class CarPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      else
        scope.where(status: 'approved')
      end
    end
  end

  def show?
    record.status == 'approved' || (user&.admin?) || record.user == user
  end

  def create?
    user.present?
  end

  def update?
    user&.admin? || record.user == user
  end

  def destroy?
    user&.admin?
  end

  def approve?
    user&.admin?
  end

  def reject?
    user&.admin?
  end

  def my_cars?
    user.present?
  end

  def pending_approval?
    user&.admin?
  end
end
