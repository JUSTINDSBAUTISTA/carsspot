class NotificationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(recipient: user)
      end
    end
  end

  def show?
    user.admin? || record.recipient == user
  end

  def mark_as_read?
    user.admin? || record.recipient == user
  end

  def approve?
    user.admin? || (record.notifiable_type == 'Rental' && record.notifiable.car.user == user)
  end

  def reject?
    user.admin? || (record.notifiable_type == 'Rental' && record.notifiable.car.user == user)
  end
end
