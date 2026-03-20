module Authorization
  module Interactors
    class RevokeRoleFromUser
      def initialize(user_role_repo: Repositories::UserRoleRepository.new)
        @user_role_repo = user_role_repo
      end
      def call(user_id:, role_slug:)
        role = ::Role.find_by!(slug: role_slug)
        @user_role_repo.revoke(user_id: user_id, role_id: role.id)
      end
    end
  end
end
