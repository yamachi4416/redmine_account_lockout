resource :users do
  patch '/:user_id/lockout/reset', to: 'users_account_lockout#reset'
end
