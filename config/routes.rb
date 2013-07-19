Transition::Application.routes.draw do
  resources :organisations do
  	resources :sites
  end

  resources :sites do
    resources :scrape_results, only: [:new, :index, :create, :edit, :update]
    resources :urls, only: [:index, :show, :update]
    get :hits_download, on: :member
    resources :mappings, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  resources :hosts,
    :constraints => { :id => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/ } do
    get :hits_download, on: :member
  end

  resources :pages

  match 'dashboard' => 'dashboard#index'

  root :to => 'organisations#index'

  namespace :admin do
    resources :content_types, only: [:index, :new, :create, :edit, :update, :destroy]
    get 'import_urls' => "import_urls#import"
    post 'import_urls' => "import_urls#import"

    root :to => 'home#index'
  end
end
