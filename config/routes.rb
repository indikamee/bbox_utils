Rails.application.routes.draw do
  resources :tickets do 
    post :email, on: :member
    post :flag_attended, on: :member
  end
  resources :people do
    post :email, on: :member
    get :agent_profile, on: :member
  end
  resources :agents
  resources :events do
    member do
      get :bulk_edit
      get :show_tickets
      post :bulk_update, :bulk_email
    end
  end
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'registrations',
    sessions: 'devise/sessions'  # Add this line to explicitly use Devise's default sessions controller
  }
  resources :users do
    post :impersonate, on: :member
    post :stop_impersonating, on: :collection
    get :edit_password, on: :member
    patch :update_password, on: :member
  end
  root "welcome#index"
  namespace :barcode do
    get :index
    post :generate_labels
  end
  namespace :admin do
    get :list_roles
    get :list_items
    post :create_role
    delete :remove_role
  end

  # Routes for AdminController
  get 'admin/new_user', to: 'admin#new_user'
  post 'admin/create_user', to: 'admin#create_user'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
