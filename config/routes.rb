Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  root to: 'application#welcome'
  namespace :v1 do
    resources :s3 do
      collection do
        post :presigned_url
      end
    end

    get 'profile', to: 'authentication#show'
    post 'login', to: 'authentication#login'
    post 'logout', to: 'authentication#logout'
    post 'refresh_token', to: 'authentication#refresh_token'
    get 'app_init', to: 'main#app_init'

    post 'google_login', to: 'authentication#social_login'
    post 'passwords/forgot', to: 'authentication#forgot_password'
    post 'passwords/confirm', to: 'authentication#confirm_reset'
    post 'passwords/reset', to: 'authentication#save'
    post 'passwords/change', to: 'authentication#password_change'
    post 'passwords/resend_code', to: 'authentication#resend_code'

    resources :users
    resources :workspaces
    resources :companies
    resources :roles

    namespace :documents do
      resources :documents
      resources :issues
      resources :issue_comments
    end

    namespace :tools do
      resources :categories
      resources :tags
      resources :glossaries
      resources :seos
    end
  end
end
