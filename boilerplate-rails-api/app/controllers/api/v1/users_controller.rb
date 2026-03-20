class Api::V1::UsersController < Api::V1::BaseController
  def index
    authorize ::User, policy_class: Authorization::Policies::UserPolicy
    users = ::User.order(:id)
    render json: { data: users.map { |user| serialize_user(user) }, meta: { total: users.count } }
  end

  def show
    user = ::User.find(params[:id])
    authorize user, policy_class: Authorization::Policies::UserPolicy
    render json: { data: serialize_user(user) }
  end

  def update
    user = ::User.find(params[:id])
    authorize user, policy_class: Authorization::Policies::UserPolicy
    user.update!(params.permit(:name).to_h)
    render json: { data: serialize_user(user) }
  end

  def destroy
    user = ::User.find(params[:id])
    authorize user, policy_class: Authorization::Policies::UserPolicy
    user.destroy!
    head :no_content
  end

  def assign_role
    user = ::User.find(params[:id])
    authorize user, :assign_role?, policy_class: Authorization::Policies::UserPolicy
    role = Authorization::Interactors::AssignRoleToUser.new.call(user_id: user.id, role_slug: params.require(:role_slug), expires_at: params[:expires_at])
    render json: Authorization::Presenters::RolePresenter.single(role)
  end

  def revoke_role
    user = ::User.find(params[:id])
    authorize user, :revoke_role?, policy_class: Authorization::Policies::UserPolicy
    Authorization::Interactors::RevokeRoleFromUser.new.call(user_id: user.id, role_slug: params.require(:role_slug))
    head :no_content
  end

  private

  def serialize_user(user)
    { id: user.id.to_s, type: "users", attributes: { email: user.email, name: user.name, super_admin: user.super_admin } }
  end
end
