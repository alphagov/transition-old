Transition::Application.routes.draw do
  resources :organisations do
  	resources :sites
  end

  resources :sites do
    resources :scrape_results, only: [:new, :index, :create, :edit, :update]
    resources :urls, only: [:index, :show, :update]
    resources :urls, only: [:index, :update], as: 'manual_urls', controller: 'manual_urls', path: 'manual_urls'
    get :hits_download, on: :member
    resources :mappings, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  resources :hosts,
    :constraints => { :id => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/ } do
    get :hits_download, on: :member
  end

  resources :pages

  resources :url_groups, only: [:create]
  resources :user_needs, only: [:index, :create, :edit, :update, :destroy]

  match 'dashboard' => 'dashboard#index'

  root :to => 'organisations#index'

  namespace :admin do
    resources :content_types, only: [:index, :new, :create, :edit, :update, :destroy]
    get 'import_urls' => "import_urls#import"
    post 'import_urls' => "import_urls#import"

    root :to => 'home#index'
  end
end
