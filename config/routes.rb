Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  root to: 'application#welcome'
  namespace :v1 do
    resources :users
    resources :workspaces
    resources :companies
    resources :roles

    namespace :documents do
      resources :documents do
        get :quick_access, on: :collection
      end
      resources :issues do
        post :assign, on: :collection
      end
      resources :issue_comments
      resources :categories
    end

    namespace :tools do
      resources :tags
      resources :glossaries
      resources :seos
    end

    post 'login', to: 'authentication#login'
    post 'logout', to: 'authentication#logout'
    post 'refresh_token', to: 'authentication#refresh_token'
    get 'app_init', to: 'main#app_init'
    get 'profile', to: 'authentication#show'

    post 'passwords/forgot', to: 'authentication#forgot_password'
    post 'passwords/confirm', to: 'authentication#confirm_reset'
    post 'passwords/reset', to: 'authentication#save'
    post 'passwords/change', to: 'authentication#password_change'
    post 'passwords/resend_code', to: 'authentication#resend_code'

  end
end
