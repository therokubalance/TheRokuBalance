class AddColumnAvailableInvitationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :available_invitations, :integer , { default: 2 }
  end
end
