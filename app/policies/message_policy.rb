class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(sender_id: user.id).or(scope.where(recipient_id: user.id))
    end
  end

  def index?
    true
  end

  def show?
    record.sender_id == user.id || record.recipient_id == user.id
  end

  def create?
    true
  end

  def new?
    create?
  end
end
