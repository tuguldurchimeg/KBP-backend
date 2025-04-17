class ApplicationPolicy
  attr_reader :user, :record
  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user.has_permission?(Base::RoleDetail.actions[:read], resource)
  end

  def show?
    index?
  end

  def new?
    user.has_permission?(Base::RoleDetail.actions[:write], resource)
  end

  def create?
    user.has_permission?(Base::RoleDetail.actions[:write], resource)
  end

  def update?
    create?
  end

  def edit?
    create?
  end

  def destroy?
    create?
  end

  protected

  def resource
    raise NotImplementedError
  end
end
