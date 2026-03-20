module Authorization
  module Policies
    class ApplicationPolicy
      attr_reader :user, :record
      def initialize(user, record)
        raise Pundit::NotAuthorizedError, "Usuario no autenticado" unless user
        @user = user
        @record = record
      end
      def index? = false
      def show? = false
      def create? = false
      def update? = false
      def destroy? = false
      private
      def super_admin? = user.super_admin?
      def has_permission?(slug)
        return true if super_admin?
        Authorization::Interactors::FetchUserPermissions.new.call(user_id: user.id).include?(slug)
      end
    end
  end
end
