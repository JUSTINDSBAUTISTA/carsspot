class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(sender: user).or(scope.where(recipient: user))
    end
  end

  def index?
    true
  end

  def create?
    true
  end

  def show?
    record.sender == user || record.recipient == user
  end
end
