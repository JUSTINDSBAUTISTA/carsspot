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
    record.status == 'approved' || (user.present? && (record.user == user || user.admin?))
  end

  def create?
    user.present?
  end

  def update?
    user.present? && (record.user == user || user.admin?)
  end

  def destroy?
    user.present? && (record.user == user || user.admin?)
  end

  def approve?
    user.present? && user.admin?
  end

  def reject?
    user.present? && user.admin?
  end

  def my_cars?
    user.present?
  end

  def pending_approval?
    user.present? && user.admin?
  end

  def search?
    true
  end
end
