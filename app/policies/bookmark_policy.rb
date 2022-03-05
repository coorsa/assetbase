class BookmarkPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
      # Mayeb filter here!!!
    end
  end

  def index?
    return true
  end

  # def show?
  #   return true
  # end

  def create?
    return true
  end

  def edit?
    update?
  end

  def update?
    true
  end

  def destroy?
    true
  end
end
