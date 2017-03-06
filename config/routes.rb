Rails.application.routes.draw do

  root to: 'projects#index'

  resource :projects, only: [:index, :show]
  
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
