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

  get 'admin/list_roles'
  get 'admin/list_items'
  post 'admin/create_role'
  delete 'admin/remove_role'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
