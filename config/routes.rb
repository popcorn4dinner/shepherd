Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  root to: 'projects#index'

  resources :services, only: [:new, :create]

    post '/services/:id/refresh', to: 'services#refresh', as: 'service_update'
    patch '/services/:id/status', to: 'services#update_status', as: 'service_status_update'

    get '/projects/:id/incidents', to: 'projects#incidents'
    get '/projects/:id/health', to: 'projects#health', as: 'project_health'
    get '/projects/:id', to: 'projects#show', as: 'project'
    get '/projects', to: 'projects#index', as: 'projects'

  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
