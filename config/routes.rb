Transition::Application.routes.draw do
  resources :organisations do
  	resources :sites
  end

  resources :sites do
    get :hits_download, on: :member
    resources :mappings, only: [:index]
  end

  resources :hosts,
    :constraints => { :id => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/ } do
    get :hits_download, on: :member
  end

  root :to => 'organisations#index'
end
