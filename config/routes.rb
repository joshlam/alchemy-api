Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    resources :alchemists, only: :create

    post 'authenticate', to: 'authentication#authenticate'

    resources :transmutations, param: :name, only: :show do
      collection do
        get :mind
        get :body
      end
    end

    resource :me, controller: :me, only: :show
  end
end
