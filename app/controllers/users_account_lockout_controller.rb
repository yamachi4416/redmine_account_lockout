class UsersAccountLockoutController < ApplicationController
  before_action :require_admin
  before_action :find_user

  def reset
    @user.reset_lockout
    redirect_to controller: 'users', action: 'edit', tab: 'account_lockout', id: @user
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end