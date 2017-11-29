Rails.application.routes.draw do

  root to: 'projects#index'

  resources :services, only: [:new, :create]
  post '/services/:id/update', to: 'services#update', as: 'service_update'

  get '/projects/:id/health', to: 'projects#health', as: 'project_health'
  get '/projects/:id', to: 'projects#show', as: 'project'
  get '/projects', to: 'projects#index', as: 'projects'


  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
