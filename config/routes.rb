Transition::Application.routes.draw do
  resources :organisations do
  	resources :sites
  end

  resources :sites do
    resources :urls, only: [:index, :show, :update]
    get :hits_download, on: :member
    resources :mappings, only: [:index, :new, :create, :edit, :update]
  end

  resources :hosts,
    :constraints => { :id => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/ } do
    get :hits_download, on: :member
  end

  resources :pages

  match 'dashboard' => 'dashboard#index'

  root :to => 'organisations#index'
end
