class UniversidadPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
    def edit?
      @user.has_role? :admin
    end

    def scrape?
      @user.has_role? :admin
    end

    def destroy?
      @user.has_role? :admin
    end
  end

  
end
