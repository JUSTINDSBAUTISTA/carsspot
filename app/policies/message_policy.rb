class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def update?
    record.sender == user || user.admin?
  end

  def destroy?
    record.sender == user || user.admin?
  end
end
