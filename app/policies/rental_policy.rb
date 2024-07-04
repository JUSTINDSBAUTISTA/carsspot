class RentalPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user == record.user || user == record.car.user
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    user == record.user || user == record.car.user
  end

  def edit?
    update?
  end

  def destroy?
    user == record.user
  end

  def approve?
    user == record.car.user
  end

  def reject?
    user == record.car.user
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where("user_id = ? OR car_id IN (?)", user.id, user.cars.pluck(:id))
      end
    end
  end
end
