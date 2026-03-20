module Authorization
  module Policies
    class FormSchemaPolicy < ApplicationPolicy
      def create? = has_permission?("forms:create")
      def update? = has_permission?("forms:update")
      def destroy? = has_permission?("forms:destroy")
    end
  end
end
