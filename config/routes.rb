Transition::Application.routes.draw do
  resources :organisations


  resources :sites


  resources :hosts


  root :to => 'dashboard#index'
end
