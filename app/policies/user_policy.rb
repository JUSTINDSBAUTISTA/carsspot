class UserPolicy < ApplicationPolicy
  def message?
    user.present? && (CarView.exists?(user: user, car: record.cars) ||
                      CarView.exists?(user: record, car: user.cars) ||
                      Message.exists?(sender: user, recipient: record) ||
                      Message.exists?(sender: record, recipient: user))
  end

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
