require 'rails_helper'

RSpec.describe Authorization::Policies::UserPolicy do
  let(:record) { create(:user) }

  it 'super_admin can do everything' do
    user = create(:user, super_admin: true)
    policy = described_class.new(user, record)
    expect(policy.index?).to be(true)
    expect(policy.show?).to be(true)
    expect(policy.update?).to be(true)
    expect(policy.destroy?).to be(true)
  end

  it 'user with users:read can index and show' do
    user = create(:user)
    role = create(:role)
    permission = create(:permission, resource: 'users', action: 'read')
    RolePermission.create!(role: role, permission: permission)
    UserRole.create!(user: user, role: role)
    policy = described_class.new(user, record)
    expect(policy.index?).to be(true)
    expect(policy.show?).to be(true)
  end

  it 'user without permissions cannot do anything' do
    user = create(:user)
    policy = described_class.new(user, record)
    expect(policy.index?).to be(false)
    expect(policy.show?).to be(false)
    expect(policy.create?).to be(false)
    expect(policy.destroy?).to be(false)
  end
end
