class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(sender_id: user.id).or(scope.where(recipient_id: user.id))
    end
  end

  def index?
    true
  end

  def create?
    true
  end

  def new?
    create?
  end
end
