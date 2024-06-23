class NotificationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(recipient: user)
    end
  end

  def show?
    record.recipient == user
  end

  def mark_as_read?
    record.recipient == user
  end

  def approve?
    record.notifiable_type == 'Rental' && record.notifiable.car.user == user
  end

  def reject?
    record.notifiable_type == 'Rental' && record.notifiable.car.user == user
  end
end
